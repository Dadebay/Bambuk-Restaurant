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
    print('\n🚀 [INIT DEBUG] RestaurantMapFullPage initState çağrıldı');
    print('📍 [INIT DEBUG] Restoran konumu: lat=${widget.restaurantLocation.latitude}, lon=${widget.restaurantLocation.longitude}');
    print('🏷️ [INIT DEBUG] Restoran adı: ${widget.restaurantName}\n');

    // Harita başlatıldığında restoran konumuna odaklan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🗺️ [INIT DEBUG] PostFrameCallback çağrıldı, _mapReady: $_mapReady');
      if (_mapReady) {
        _mapController.move(widget.restaurantLocation, _currentZoom);
        print('✅ [INIT DEBUG] Harita başlangıç konumuna odaklandı\n');
      }
    });
  }

  // ── Kullanıcı konumunu al ──────────────────────────────────────────────────
  Future<void> _fetchUserLocation() async {
    print('\n🔍 [KONUM DEBUG] _fetchUserLocation başladı');
    if (_isLocating) {
      print('⏳ [KONUM DEBUG] Konum alma zaten çalışıyor, tekrar çağrı atlandı');
      return;
    }
    if (mounted) setState(() => _isLocating = true);
    final provDil = Provider.of<Which_page>(context, listen: false).dil;
    try {
      print('🔑 [KONUM DEBUG] İzin kontrolü başlatılıyor...');
      final bool ok = await _ensurePermission();
      if (!mounted) return;
      print('🔑 [KONUM DEBUG] İzin kontrolü sonucu: $ok');
      if (!ok) {
        print('❌ [KONUM DEBUG] İzin alınamadı!');
        _showSnack(Constants.location_permission_needed[provDil]);
        return;
      }

      final LatLng loc = await _resolveUserPosition();
      if (!mounted) return;

      print('🎯 [KONUM DEBUG] LatLng alındı: lat=${loc.latitude}, lon=${loc.longitude}');
      setState(() {
        _userLocation = loc;
      });
      print('✅ [KONUM DEBUG] State güncellendi');

      // Haritayı kullanıcı konumuna odakla
      _mapController.move(loc, 14.0);
      print('🗺️ [KONUM DEBUG] Harita konuma odaklandı');
      _showSnack(Constants.location_found[provDil]);
      print('✅ [KONUM DEBUG] _fetchUserLocation başarıyla tamamlandı\n');
    } on TimeoutException catch (e) {
      print('❌ [KONUM DEBUG] TimeoutException yakalandı: $e');
      if (mounted) _showSnack(Constants.location_timeout_msg[provDil]);
    } catch (e) {
      print('❌ [KONUM DEBUG] Beklenmeyen hata: $e');
      if (mounted) _showSnack('${Constants.location_error_msg[provDil]}$e');
    } finally {
      if (mounted) setState(() => _isLocating = false);
      print('🏁 [KONUM DEBUG] _fetchUserLocation finally bloğu - _isLocating = false\n');
    }
  }

  static const _nativeChannel = MethodChannel('com.softpage.bamboo/location');

  Future<LatLng> _resolveUserPosition() async {
    print('🧭 [KONUM DEBUG] 3 katmanlı konum çözümü başladı');

    // ======== 1) NATIVE ANDROID METHOD CHANNEL ========
    // Android LocationManager API'ını direkt çağırır, Flutter plugin'lerine bağlı değil
    try {
      print('📍 [KONUM DEBUG] Native Android channel deneniyor...');
      final Map<dynamic, dynamic>? data = await _nativeChannel.invokeMethod<Map<dynamic, dynamic>>('getLocation').timeout(const Duration(seconds: 30));
      if (data != null) {
        final lat = (data['latitude'] as num).toDouble();
        final lon = (data['longitude'] as num).toDouble();
        final source = data['source'] ?? 'unknown';
        print('✅ [KONUM DEBUG] Native channel BAŞARILI: lat=$lat, lon=$lon (source: $source)');
        return LatLng(lat, lon);
      }
    } on PlatformException catch (e) {
      print('⚠️ [KONUM DEBUG] Native channel PlatformException: ${e.code} - ${e.message}');
    } on TimeoutException {
      print('⏱️ [KONUM DEBUG] Native channel timeout');
    } catch (e) {
      print('⚠️ [KONUM DEBUG] Native channel hatası: $e');
    }

    // ======== 2) LOCATION PAKETi FALLBACK ========
    try {
      print('📍 [KONUM DEBUG] location paketi deneniyor...');
      final loc = Location();
      await loc.changeSettings(
        accuracy: LocationAccuracy.low,
        interval: 500,
        distanceFilter: 0,
      );
      final LocationData locData = await loc.getLocation().timeout(const Duration(seconds: 10));
      final lat = locData.latitude;
      final lon = locData.longitude;
      if (lat != null && lon != null) {
        print('✅ [KONUM DEBUG] location paketi başarılı: lat=$lat, lon=$lon');
        return LatLng(lat, lon);
      }
    } on TimeoutException {
      print('⏱️ [KONUM DEBUG] location paketi timeout');
    } catch (e) {
      print('⚠️ [KONUM DEBUG] location paketi hatası: $e');
    }

    // ======== 3) IP GEOLOCATION FALLBACK ========
    // GPS/Wi-Fi hiç çalışmazsa, IP adresinden yaklaşık konum al (şehir düzeyinde)
    final ipApis = [
      'https://freeipapi.com/api/json',
      'https://ipwho.is/',
    ];
    for (final apiUrl in ipApis) {
      try {
        print('🌐 [KONUM DEBUG] IP geolocation deneniyor: $apiUrl');
        final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 8));
        if (response.statusCode == 200) {
          final map = jsonDecode(response.body) as Map<String, dynamic>;
          // freeipapi.com: latitude/longitude, ipwho.is: latitude/longitude + success field
          final success = map['success'] ?? true; // freeipapi doesn't have a success field
          final rawLat = map['latitude'] ?? map['lat'];
          final rawLon = map['longitude'] ?? map['lon'];
          if (success != false && rawLat != null && rawLon != null) {
            final lat = (rawLat as num).toDouble();
            final lon = (rawLon as num).toDouble();
            final city = map['cityName'] ?? map['city'] ?? '';
            print('✅ [KONUM DEBUG] IP geolocation başarılı: lat=$lat, lon=$lon ($city)');
            return LatLng(lat, lon);
          }
        }
      } on TimeoutException {
        print('⏱️ [KONUM DEBUG] IP geolocation timeout: $apiUrl');
      } catch (e) {
        print('⚠️ [KONUM DEBUG] IP geolocation hatası ($apiUrl): $e');
      }
    }

    print('❌ [KONUM DEBUG] Hiçbir yöntemle konum alınamadı');
    throw TimeoutException('Konum alınamadı');
  }

  // ── Rota çiz ──────────────────────────────────────────────────────────────
  Future<void> _drawRoute() async {
    print('\n🛣️ [ROTA DEBUG] _drawRoute başladı');
    final provDil = Provider.of<Which_page>(context, listen: false).dil;
    if (_userLocation == null) {
      print('⚠️ [ROTA DEBUG] Kullanıcı konumu null, konum alınıyor...');
      await _fetchUserLocation();
      if (_userLocation == null) {
        print('❌ [ROTA DEBUG] Konum alınamadı, rota çizilemiyor!');
        _showSnack(Constants.activate_location_first[provDil]);
        return;
      }
      print('✅ [ROTA DEBUG] Kullanıcı konumu alındı: $_userLocation');
    } else {
      print('✅ [ROTA DEBUG] Kullanıcı konumu zaten mevcut: $_userLocation');
    }

    if (mounted) setState(() => _isRouting = true);
    try {
      print('🌐 [ROTA DEBUG] OSRM rota hesaplama başlıyor...');
      final bool success = await _fetchOsrmRoute(_userLocation!, widget.restaurantLocation);
      if (!mounted) return;
      print('📊 [ROTA DEBUG] OSRM sonucu: success=$success');
      if (!success) {
        print('❌ [ROTA DEBUG] Yol ağı üzerinden rota bulunamadı');
        _showSnack(Constants.route_error_msg[provDil]);
        return;
      } else {
        print('✅ [ROTA DEBUG] OSRM rotası başarılı: ${_routePoints.length} nokta');
      }

      // Rotaya sığacak şekilde haritayı ayarla
      if (_routePoints.isNotEmpty) {
        print('🗺️ [ROTA DEBUG] Harita rota sınırlarına odaklanıyor...');
        final bounds = LatLngBounds.fromPoints(_routePoints);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(80),
          ),
        );
        _showSnack(Constants.route_drawn[provDil]);
        print('✅ [ROTA DEBUG] Rota çizildi ve harita ayarlandı');
      } else {
        print('⚠️ [ROTA DEBUG] _routePoints boş, harita ayarlanamadı!');
      }
    } catch (e) {
      print('❌ [ROTA DEBUG] _drawRoute hatası: $e');
    } finally {
      if (mounted) setState(() => _isRouting = false);
      print('🏁 [ROTA DEBUG] _drawRoute tamamlandı\n');
    }
  }

  Future<bool> _fetchOsrmRoute(LatLng from, LatLng to) async {
    print('\n🌐 [OSRM DEBUG] _fetchOsrmRoute başladı');
    print('📍 [OSRM DEBUG] From: lat=${from.latitude}, lon=${from.longitude}');
    print('📍 [OSRM DEBUG] To: lat=${to.latitude}, lon=${to.longitude}');

    try {
      final snappedFrom = await _snapToRoad(from);
      final snappedTo = await _snapToRoad(to);
      print(
        '🧲 [OSRM DEBUG] Snap sonrası: from=${snappedFrom.latitude},${snappedFrom.longitude} to=${snappedTo.latitude},${snappedTo.longitude}',
      );

      final routeEndpoints = [
        'https://router.project-osrm.org',
        'http://router.project-osrm.org',
      ];

      for (final base in routeEndpoints) {
        final uri = Uri.parse(
          '$base/route/v1/driving/'
          '${snappedFrom.longitude},${snappedFrom.latitude};'
          '${snappedTo.longitude},${snappedTo.latitude}'
          '?overview=full&geometries=geojson&steps=true&continue_straight=true',
        );

        for (int attempt = 1; attempt <= 2; attempt++) {
          print('🔗 [OSRM DEBUG] URL: $uri (deneme $attempt/2)');
          final points = await _fetchRoutePointsFromUri(uri);
          if (points.isNotEmpty) {
            if (mounted) setState(() => _routePoints = points);
            print('✅ [OSRM DEBUG] _routePoints state güncellendi (${points.length} nokta)');
            print('✅ [OSRM DEBUG] _fetchOsrmRoute başarılı\n');
            return true;
          }
        }
      }
    } catch (e) {
      print('❌ [OSRM DEBUG] Beklenmeyen hata: $e');
    }

    return false;
  }

  Future<LatLng> _snapToRoad(LatLng input) async {
    final endpoints = [
      'https://router.project-osrm.org',
      'http://router.project-osrm.org',
    ];

    for (final base in endpoints) {
      final uri = Uri.parse('$base/nearest/v1/driving/${input.longitude},${input.latitude}?number=1');
      try {
        print('🧲 [OSRM DEBUG] Nearest URL: $uri');
        final res = await http.get(uri).timeout(const Duration(seconds: 10));
        if (res.statusCode != 200) {
          print('⚠️ [OSRM DEBUG] Nearest status başarısız: ${res.statusCode}');
          continue;
        }
        final map = jsonDecode(res.body) as Map<String, dynamic>;
        final ways = map['waypoints'] as List?;
        if (ways == null || ways.isEmpty) {
          print('⚠️ [OSRM DEBUG] Nearest waypoint bulunamadı');
          continue;
        }
        final loc = ways[0]['location'] as List;
        final snapped = LatLng((loc[1] as num).toDouble(), (loc[0] as num).toDouble());
        print('✅ [OSRM DEBUG] Nearest snap başarılı: ${snapped.latitude},${snapped.longitude}');
        return snapped;
      } on TimeoutException {
        print('⏱️ [OSRM DEBUG] Nearest timeout: $base');
      } catch (e) {
        print('⚠️ [OSRM DEBUG] Nearest hata: $e');
      }
    }

    print('ℹ️ [OSRM DEBUG] Snap alınamadı, orijinal koordinat kullanılacak');
    return input;
  }

  Future<List<LatLng>> _fetchRoutePointsFromUri(Uri uri) async {
    try {
      print('⏳ [OSRM DEBUG] HTTP isteği gönderiliyor (timeout: 14s)...');
      final res = await http.get(uri).timeout(const Duration(seconds: 14));
      print('📡 [OSRM DEBUG] HTTP yanıt alındı: statusCode=${res.statusCode}');

      if (res.statusCode != 200) {
        return [];
      }

      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final routes = map['routes'] as List?;
      if (routes == null || routes.isEmpty) {
        return [];
      }

      final coords = routes[0]['geometry']['coordinates'] as List;
      final points = coords.map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble())).toList();
      print('🛣️ [OSRM DEBUG] Geçerli rota alındı: ${points.length} nokta');
      return points;
    } on TimeoutException catch (e) {
      print('⏱️ [OSRM DEBUG] Timeout hatası: $e');
      return [];
    } catch (e) {
      print('❌ [OSRM DEBUG] Rota parse/istek hatası: $e');
      return [];
    }
  }

  // ── Rotayı temizle ────────────────────────────────────────────────────────
  void _clearRoute() {
    print('\n🧹 [ROTA DEBUG] _clearRoute başladı');
    final provDil = Provider.of<Which_page>(context, listen: false).dil;
    setState(() {
      _routePoints = [];
    });
    print('✅ [ROTA DEBUG] Route points temizlendi');
    _mapController.move(widget.restaurantLocation, 15.0);
    print('🗺️ [ROTA DEBUG] Harita restorana odaklandı');
    _showSnack(Constants.route_cleared[provDil]);
    print('✅ [ROTA DEBUG] _clearRoute tamamlandı\n');
  }

  // ── Restorana odaklan ─────────────────────────────────────────────────────
  void _focusOnRestaurant() {
    print('\n🎯 [NAVİGASYON DEBUG] _focusOnRestaurant başladı');
    _mapController.move(widget.restaurantLocation, 16.0);
    print('🗺️ [NAVİGASYON DEBUG] Harita restorana odaklandı (zoom: 16.0)\n');
  }

  // ── İzin kontrolü (location paketi kullanır) ──────────────────────────────
  Future<bool> _ensurePermission() async {
    print('\n🔐 [İZİN DEBUG] _ensurePermission başladı');

    final loc = Location();

    bool serviceEnabled = await loc.serviceEnabled();
    print('📍 [İZİN DEBUG] Konum servisi aktif mi? $serviceEnabled');

    if (!serviceEnabled) {
      print('⚠️ [İZİN DEBUG] Konum servisi kapalı, açılması isteniyor...');
      serviceEnabled = await loc.requestService();
      print('🔄 [İZİN DEBUG] requestService sonucu: $serviceEnabled');
      if (!serviceEnabled) {
        print('❌ [İZİN DEBUG] Konum servisi açılmadı!');
        return false;
      }
    }

    PermissionStatus perm = await loc.hasPermission();
    print('🔍 [İZİN DEBUG] Mevcut izin durumu: $perm');

    if (perm == PermissionStatus.denied) {
      print('⚠️ [İZİN DEBUG] İzin reddedilmiş, izin isteniyor...');
      perm = await loc.requestPermission();
      print('💬 [İZİN DEBUG] İzin isteği sonucu: $perm');
      if (perm == PermissionStatus.denied) {
        print('❌ [İZİN DEBUG] Kullanıcı izni reddetti!');
        return false;
      }
    }

    if (perm == PermissionStatus.deniedForever) {
      print('🚫 [İZİN DEBUG] İzin kalıcı olarak reddedilmiş! Ayarlara yönlendiriliyor...');
      if (mounted) {
        final result = await _showPermissionDialog();
        if (result == true) await Geolocator.openAppSettings();
      }
      return false;
    }

    final granted = perm == PermissionStatus.granted || perm == PermissionStatus.grantedLimited;
    print('✅ [İZİN DEBUG] _ensurePermission sonucu: $granted (izin: $perm)\n');
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
            Icon(Icons.location_disabled, color: Colors.orange, size: 28),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    print('💬 [SNACKBAR DEBUG] Mesaj gösteriliyor: "$msg"');
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
          icon: Icon(IconlyLight.arrow_left_circle, color: Colors.black),
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
              icon: Icon(Icons.clear, color: Colors.red),
              tooltip: Constants.clear_route_tooltip[provDil],
              onPressed: () {
                print('\n🔘 [BUTON DEBUG] "Rotayı Temizle" butonu basıldı');
                _clearRoute();
              },
            ),
          IconButton(
            icon: Icon(Icons.restaurant, color: AppColors.primary),
            tooltip: Constants.focus_restaurant_tooltip[provDil],
            onPressed: () {
              print('\n🔘 [BUTON DEBUG] "Restorana Odaklan" butonu basıldı');
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
            print('\n🗺️ [MAP DEBUG] onMapReady çağrıldı - Harita hazır!');
            if (mounted) setState(() => _mapReady = true);
            print('✅ [MAP DEBUG] _mapReady = true olarak ayarlandı\n');
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
                            color: AppColors.primary.withOpacity(0.5),
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
                    CustomPaint(
                      size: const Size(16, 10),
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
                          color: Colors.blueAccent.withOpacity(0.5),
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
                print('\n🔘 [BUTON DEBUG] Konum butonu basıldı');
                _fetchUserLocation();
              },
              backgroundColor: Colors.white,
              child: Icon(
                _userLocation != null ? IconlyBold.location : IconlyLight.location,
                color: AppColors.primary,
              ),
            ),
          if (_isLocating)
            FloatingActionButton(
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
                      print('\n🔘 [BUTON DEBUG] "Yolu Göster" butonu basıldı');
                      _drawRoute();
                    },
              backgroundColor: AppColors.primary,
              icon: _isRouting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.directions, color: Colors.white, size: 24),
              label: Text(
                _isRouting ? Constants.calculating_route[provDil] : Constants.show_route[provDil],
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
              icon: const Icon(Icons.check_circle, color: Colors.white, size: 24),
              label: Text(
                Constants.route_active_label[provDil],
                style: TextStyle(
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
