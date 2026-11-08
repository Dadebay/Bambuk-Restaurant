import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class RestaurantMapFullPage extends StatefulWidget {
  final LatLng restaurantLocation;
  final String restaurantName;

  const RestaurantMapFullPage({
    super.key,
    required this.restaurantLocation,
    required this.restaurantName,
  });

  @override
  State<RestaurantMapFullPage> createState() => _RestaurantMapFullPageState();
}

class _RestaurantMapFullPageState extends State<RestaurantMapFullPage> {
  final MapController _mapController = MapController();

  LatLng? _userLocation;
  List<LatLng> _routePoints = [];
  bool _isLocating = false;
  bool _isRouting = false;
  bool _mapReady = false;
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();

    // Harita başlatıldığında restoran konumuna odaklan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mapReady) {
        _mapController.move(widget.restaurantLocation, _currentZoom);
      }
    });
  }

  // ── Kullanıcı konumunu al ──────────────────────────────────────────────────
  Future<void> _fetchUserLocation() async {
    if (_isLocating) {
      return;
    }
    if (mounted) setState(() => _isLocating = true);
    final provDil = Provider.of<Which_page>(context, listen: false).dil;
    try {
      final bool ok = await _ensurePermission();
      if (!mounted) return;
      if (!ok) {
        _showSnack(Constants.location_permission_needed[provDil]);
        return;
      }

      final LatLng loc = await _resolveUserPosition();
      if (!mounted) return;

      setState(() {
        _userLocation = loc;
      });

      // Haritayı kullanıcı konumuna odakla
      _mapController.move(loc, 14.0);
      _showSnack(Constants.location_found[provDil]);
    } on TimeoutException {
      if (mounted) _showSnack(Constants.location_timeout_msg[provDil]);
    } catch (_) {
      if (mounted) _showSnack(Constants.location_error_msg[provDil]);
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  static const _nativeChannel = MethodChannel('com.softpage.bamboo/location');

  Future<LatLng> _resolveUserPosition() async {
    // ======== 1) NATIVE ANDROID METHOD CHANNEL ========
    // Android LocationManager API'ını direkt çağırır, Flutter plugin'lerine bağlı değil
    try {
      final Map<dynamic, dynamic>? data = await _nativeChannel
          .invokeMethod<Map<dynamic, dynamic>>('getLocation')
          .timeout(const Duration(seconds: 30));
      if (data != null) {
        final lat = (data['latitude'] as num).toDouble();
        final lon = (data['longitude'] as num).toDouble();
        return LatLng(lat, lon);
      }
    } on PlatformException {
    } on TimeoutException {
    } catch (e) {}

    // ======== 2) LOCATION PAKETi FALLBACK ========
    try {
      final loc = Location();
      await loc.changeSettings(
        accuracy: LocationAccuracy.low,
        interval: 500,
        distanceFilter: 0,
      );
      final LocationData locData =
          await loc.getLocation().timeout(const Duration(seconds: 10));
      final lat = locData.latitude;
      final lon = locData.longitude;
      if (lat != null && lon != null) {
        return LatLng(lat, lon);
      }
    } on TimeoutException {
    } catch (e) {}

    // ======== 3) IP GEOLOCATION FALLBACK ========
    // GPS/Wi-Fi hiç çalışmazsa, IP adresinden yaklaşık konum al (şehir düzeyinde)
    final ipApis = [
      'https://freeipapi.com/api/json',
      'https://ipwho.is/',
    ];
    for (final apiUrl in ipApis) {
      try {
        final response = await http
            .get(Uri.parse(apiUrl))
            .timeout(const Duration(seconds: 8));
        if (response.statusCode == 200) {
          final map = jsonDecode(response.body) as Map<String, dynamic>;
          // freeipapi.com: latitude/longitude, ipwho.is: latitude/longitude + success field
          final success =
              map['success'] ?? true; // freeipapi doesn't have a success field
          final rawLat = map['latitude'] ?? map['lat'];
          final rawLon = map['longitude'] ?? map['lon'];
          if (success != false && rawLat != null && rawLon != null) {
            final lat = (rawLat as num).toDouble();
            final lon = (rawLon as num).toDouble();
            return LatLng(lat, lon);
          }
        }
      } on TimeoutException {
      } catch (e) {}
    }

    throw TimeoutException('Konum alınamadı');
  }

  // ── Rota çiz ──────────────────────────────────────────────────────────────
  Future<void> _drawRoute() async {
    final provDil = Provider.of<Which_page>(context, listen: false).dil;
    if (_userLocation == null) {
      await _fetchUserLocation();
      if (_userLocation == null) {
        _showSnack(Constants.activate_location_first[provDil]);
        return;
      }
    } else {}

    if (mounted) setState(() => _isRouting = true);
    try {
      final bool success =
          await _fetchOsrmRoute(_userLocation!, widget.restaurantLocation);
      if (!mounted) return;
      if (!success) {
        _showSnack(Constants.route_error_msg[provDil]);
        return;
      } else {}

      // Rotaya sığacak şekilde haritayı ayarla
      if (_routePoints.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints(_routePoints);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(80),
          ),
        );
        _showSnack(Constants.route_drawn[provDil]);
      } else {}
    } catch (e) {
    } finally {
      if (mounted) setState(() => _isRouting = false);
    }
  }

  Future<bool> _fetchOsrmRoute(LatLng from, LatLng to) async {
    try {
      final snappedFrom = await _snapToRoad(from);
      final snappedTo = await _snapToRoad(to);

      final routeEndpoints = ['https://router.project-osrm.org'];

      for (final base in routeEndpoints) {
        final uri = Uri.parse(
          '$base/route/v1/driving/'
          '${snappedFrom.longitude},${snappedFrom.latitude};'
          '${snappedTo.longitude},${snappedTo.latitude}'
          '?overview=full&geometries=geojson&steps=true&continue_straight=true',
        );

        for (int attempt = 1; attempt <= 2; attempt++) {
          final points = await _fetchRoutePointsFromUri(uri);
          if (points.isNotEmpty) {
            if (mounted) setState(() => _routePoints = points);
            return true;
          }
        }
      }
    } catch (e) {}

    return false;
  }

  Future<LatLng> _snapToRoad(LatLng input) async {
    final endpoints = ['https://router.project-osrm.org'];

    for (final base in endpoints) {
      final uri = Uri.parse(
          '$base/nearest/v1/driving/${input.longitude},${input.latitude}?number=1');
      try {
        final res = await http.get(uri).timeout(const Duration(seconds: 10));
        if (res.statusCode != 200) {
          continue;
        }
        final map = jsonDecode(res.body) as Map<String, dynamic>;
        final ways = map['waypoints'] as List?;
        if (ways == null || ways.isEmpty) {
          continue;
        }
        final loc = ways[0]['location'] as List;
        final snapped =
            LatLng((loc[1] as num).toDouble(), (loc[0] as num).toDouble());
        return snapped;
      } on TimeoutException {
      } catch (e) {}
    }

    return input;
  }

  Future<List<LatLng>> _fetchRoutePointsFromUri(Uri uri) async {
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 14));

      if (res.statusCode != 200) {
        return [];
      }

      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = map['routes'] as List?;
      if (routes == null || routes.isEmpty) {
        return [];
      }

      final coords = routes[0]['geometry']['coordinates'] as List;
      final points = coords
          .map(
              (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();
      return points;
    } on TimeoutException {
      return [];
    } catch (e) {
      return [];
    }
  }

  // ── Rotayı temizle ────────────────────────────────────────────────────────
  void _clearRoute() {
    final provDil = Provider.of<Which_page>(context, listen: false).dil;
    setState(() {
      _routePoints = [];
    });
    _mapController.move(widget.restaurantLocation, 15.0);
    _showSnack(Constants.route_cleared[provDil]);
  }

  // ── Restorana odaklan ─────────────────────────────────────────────────────
  void _focusOnRestaurant() {
    _mapController.move(widget.restaurantLocation, 16.0);
  }

  // ── İzin kontrolü (location paketi kullanır) ──────────────────────────────
  Future<bool> _ensurePermission() async {
    final loc = Location();

    bool serviceEnabled = await loc.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await loc.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus perm = await loc.hasPermission();

    if (perm == PermissionStatus.denied) {
      perm = await loc.requestPermission();
      if (perm == PermissionStatus.denied) {
        return false;
      }
    }

    if (perm == PermissionStatus.deniedForever) {
      if (mounted) {
        final result = await _showPermissionDialog();
        if (result == true) await Geolocator.openAppSettings();
      }
      return false;
    }

    final granted = perm == PermissionStatus.granted ||
        perm == PermissionStatus.grantedLimited;
    return granted;
  }

  Future<bool?> _showPermissionDialog() {
    final provDil = Provider.of<Which_page>(context, listen: false).dil;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.location_disabled, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                Constants.location_permission_required[provDil],
                style: const TextStyle(fontSize: 16, fontFamily: 'GilroyBold'),
              ),
            ),
          ],
        ),
        content: Text(
          Constants.location_permission_message[provDil],
          style: const TextStyle(fontSize: 14, fontFamily: 'Monto'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              Constants.ru_cancel[provDil],
              style: TextStyle(color: Colors.grey[600], fontFamily: 'Semi'),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              Constants.go_to_settings[provDil],
              style: const TextStyle(color: Colors.white, fontFamily: 'Semi'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provDil = Provider.of<Which_page>(context).dil;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.restaurantName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'GilroyBold',
              ),
            ),
            if (_routePoints.isNotEmpty)
              Text(
                Constants.route_showing_subtitle[provDil],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontFamily: 'Monto',
                ),
              ),
          ],
        ),
        actions: [
          if (_routePoints.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              tooltip: Constants.clear_route_tooltip[provDil],
              onPressed: () {
                _clearRoute();
              },
            ),
          IconButton(
            icon: const Icon(Icons.restaurant, color: AppColors.primary),
            tooltip: Constants.focus_restaurant_tooltip[provDil],
            onPressed: () {
              _focusOnRestaurant();
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: widget.restaurantLocation,
          initialZoom: _currentZoom,
          minZoom: 3,
          maxZoom: 22,
          onMapReady: () {
            if (mounted) setState(() => _mapReady = true);
          },
          onPositionChanged: (position, hasGesture) {
            _currentZoom = position.zoom ?? _currentZoom;
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://map.ayterek.com/tile/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.softpage.bamboo',
            maxZoom: 22,
            minZoom: 3,
          ),

          // ── Rota çizgisi ──────────────────────────────────────────────────
          if (_routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _routePoints,
                  strokeWidth: 6,
                  color: AppColors.primary,
                  borderStrokeWidth: 2,
                  borderColor: Colors.white,
                ),
              ],
            ),

          // ── Marker'lar ────────────────────────────────────────────────────
          MarkerLayer(
            markers: [
              // Restoran marker
              Marker(
                point: widget.restaurantLocation,
                width: 60,
                height: 75,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const CustomPaint(
                      size: Size(16, 10),
                      painter: _ArrowPainter(AppColors.primary),
                    ),
                  ],
                ),
              ),

              // Kullanıcı konumu marker
              if (_userLocation != null)
                Marker(
                  point: _userLocation!,
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_pin,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      // ── Floating Action Buttons ──────────────────────────────────────────
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Konumumu göster butonu
          if (!_isLocating)
            FloatingActionButton(
              heroTag: 'location',
              onPressed: () {
                _fetchUserLocation();
              },
              backgroundColor: Colors.white,
              child: Icon(
                _userLocation != null
                    ? IconlyBold.location
                    : IconlyLight.location,
                color: AppColors.primary,
              ),
            ),
          if (_isLocating)
            const FloatingActionButton(
              heroTag: 'location_loading',
              onPressed: null,
              backgroundColor: Colors.white,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Yolu göster butonu - ExtendedFAB
          if (_userLocation != null && _routePoints.isEmpty)
            FloatingActionButton.extended(
              heroTag: 'route',
              onPressed: _isRouting
                  ? null
                  : () {
                      _drawRoute();
                    },
              backgroundColor: AppColors.primary,
              icon: _isRouting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.directions, color: Colors.white, size: 24),
              label: Text(
                _isRouting
                    ? Constants.calculating_route[provDil]
                    : Constants.show_route[provDil],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Semi',
                  fontSize: 15,
                ),
              ),
            ),

          // Rota gösteriliyor durumu
          if (_routePoints.isNotEmpty)
            FloatingActionButton.extended(
              heroTag: 'route_active',
              onPressed: null,
              backgroundColor: Colors.green,
              icon:
                  const Icon(Icons.check_circle, color: Colors.white, size: 24),
              label: Text(
                Constants.route_active_label[provDil],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Semi',
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Arrow Painter ─────────────────────────────────────────────────────────────
class _ArrowPainter extends CustomPainter {
  final Color color;
  const _ArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
