import 'package:bamboo/my_pages2/sub_cat.dart';
import 'package:bamboo/providers/page1provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:bamboo/values/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CategoryCart extends StatefulWidget {
  final int id;
  final String name_tm;
  final String name_ru;
  final String name_en;
  final String image;
  final dynamic children;
  final ScrollController? scrollController;
  final bool isGrid;

  const CategoryCart(this.id, this.name_tm, this.name_ru, this.name_en, this.image, this.children, {super.key, this.scrollController, this.isGrid = true});

  @override
  _CategoryCartState createState() => _CategoryCartState();
}

class _CategoryCartState extends State<CategoryCart> {
  final _cardKey = GlobalKey();
  bool _pressed = false;

  /// Planşet: gysga gyra 600dp-den uly bolsa.
  bool get _isTablet => MediaQuery.of(context).size.shortestSide >= 600;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  double _parallaxAlignmentY() {
    final ctrl = widget.scrollController;
    if (ctrl == null || !ctrl.hasClients) return 0;
    final box = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return 0;
    final viewport = RenderAbstractViewport.of(box);
    final vh = MediaQuery.of(context).size.height;
    final revealOffset = viewport.getOffsetToReveal(box, 0.5).offset;
    final rel = (ctrl.offset - revealOffset) / vh;
    return rel.clamp(-0.5, 0.5) * 2;
  }

  @override
  Widget build(BuildContext context) {
    final int dil = Provider.of<Which_page>(context).dil;
    final String name = dil == 1
        ? widget.name_tm
        : dil == 0
            ? widget.name_ru
            : widget.name_en;

    return GestureDetector(
      onTap: () {
        Constants.children = widget.children;
        Constants.myCatID = widget.id;
        Constants.myCatName = name;
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SubCat()));
      },
      // Basylanda kart azajyk kiçelýär - degilendigi duýulýar.
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: widget.isGrid ? _buildGridCard(context, name) : _buildListCard(context, name),
      ),
    );
  }

  Widget _buildListCard(BuildContext context, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            SizedBox.expand(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.image,
                memCacheWidth: 800,
                memCacheHeight: 400,
                placeholder: (_, __) => Container(color: Colors.grey.shade100),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: Image.asset(logoImage, fit: BoxFit.cover),
                ),
              ),
            ),
            // gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 90,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.80)],
                  ),
                ),
              ),
            ),
            // category name
            Positioned(
              bottom: 14,
              left: 16,
              right: 60,
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'GilroyBold',
                  fontSize: 17,
                  height: 1.25,
                  shadows: [
                    Shadow(color: Colors.black54, offset: Offset(0, 1), blurRadius: 4),
                  ],
                ),
              ),
            ),
            // arrow button
            Positioned(
              bottom: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.90),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, String name) {
    // Planşetde kart ulurak, şonuň üçin gyralar hem has tegelek bolmaly -
    // kiçijik radius uly kartda "kesilen" ýaly görünýär.
    final double radius = _isTablet ? 22 : 14;
    final double stripH = _isTablet ? 64 : 58;
    final double fontSize = _isTablet ? 15 : 13;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalH = constraints.maxHeight.isFinite ? constraints.maxHeight : 190.0;
        final totalW = constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0;
        final imageH = totalH - stripH;
        final cacheW = (totalW * 2).toInt(); // retina üçin x2
        final cacheH = (imageH * 2).toInt();

        return Container(
          key: _cardKey,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            // Iki gatly kölege: ýakyn we ýiti + uzak we ýumşak. Bir gatly
            // kölegeden tapawutlylykda kart tekiz ýerde duran ýaly görünýär.
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 1)),
              BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 18, offset: const Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Ýokarky bölek: surat ────────────────────────
                SizedBox(
                  width: totalW,
                  height: imageH,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        // `fill` suraty gerýärdi - telefonda we planşetde kartyň
                        // gatnaşygy başga bolany üçin nahar süýnüp görünýärdi.
                        // `cover` gerýän däl-de, gyrasyndan kesýär.
                        fit: BoxFit.cover,
                        imageUrl: widget.image,
                        memCacheWidth: cacheW,
                        memCacheHeight: cacheH,
                        placeholder: (_, __) => Container(color: Colors.grey.shade100),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: Center(child: Image.asset(logoImage, fit: BoxFit.contain)),
                        ),
                      ),
                      // Suratyň aşak gyrasy ak zolaga ýumşak geçýär.
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.16), Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Aşaky bölek: kategoriýanyň ady ──────────────
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: _isTablet ? 12 : 8, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'GilroyBold',
                              fontSize: fontSize,
                              height: 1.25,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Kartyň basylýandygyny aňladýan kiçijik ok.
                        Container(
                          width: _isTablet ? 26 : 22,
                          height: _isTablet ? 26 : 22,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: _isTablet ? 12 : 10,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
