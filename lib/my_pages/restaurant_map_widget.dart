import 'dart:ui' as ui;

import 'package:bamboo/my_pages/restaurant_map_full_page.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconly/iconly.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

// ─── Bambuk Restaurant koordinatları (Aşgabat) ───────────────────────────────
// ⚠️ Doğru adresi aşağıdan güncelleyin
const LatLng _restaurantLatLng = LatLng(37.9082565, 58.4019099);
const String _restaurantName = 'Bambuk Restaurant';

class RestaurantMapWidget extends StatefulWidget {
  const RestaurantMapWidget({super.key});

  @override
  State<RestaurantMapWidget> createState() => _RestaurantMapWidgetState();
}

class _RestaurantMapWidgetState extends State<RestaurantMapWidget> {
  final MapController _mapController = MapController();

  // Haritaya tıklayınca tam ekran harita sayfasına git
  void _openFullScreenMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantMapFullPage(
          restaurantLocation: _restaurantLatLng,
          restaurantName: _restaurantName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provDil = Provider.of<Which_page>(context, listen: false).dil;

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    IconlyLight.location,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.our_address[provDil],
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "GilroyBold",
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Constants.press_map_to_find_us[provDil],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Monto",
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: GestureDetector(
                onTap: _openFullScreenMap,
                child: Stack(
                  children: [
                    // ── Harita önizlemesi ────────────────────────────────────────
                    AbsorbPointer(
                      absorbing: true,
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _restaurantLatLng,
                          initialZoom: 18.0,
                          interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'http://216.250.9.138:5050/tile/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.softpage.bamboo',
                            maxZoom: 22,
                            minZoom: 3,
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _restaurantLatLng,
                                width: 56,
                                height: 70,
                                alignment: Alignment.topCenter,
                                child: _RestaurantMarker(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Tap overlay ─────────────────────────────────────────────
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.map, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  Constants.open_map[provDil],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'GilroyBold',
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ── Restoran adı (sol üst) ──────────────────────────────────
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restaurant, color: AppColors.primary, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              _restaurantName,
                              style: const TextStyle(
                                fontFamily: 'GilroyBold',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Restoran pin marker'ı (daire + aşağı ok)
class _RestaurantMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.45),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.restaurant, color: Colors.white, size: 26),
        ),
        CustomPaint(
          size: const Size(14, 8),
          painter: _ArrowPainter(AppColors.primary),
        ),
      ],
    );
  }
}

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
