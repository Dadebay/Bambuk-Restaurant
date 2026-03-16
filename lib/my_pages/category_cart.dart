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

  CategoryCart(this.id, this.name_tm, this.name_ru, this.name_en, this.image, this.children, {super.key, this.scrollController, this.isGrid = true});

  @override
  _CategoryCartState createState() => _CategoryCartState();
}

class _CategoryCartState extends State<CategoryCart> {
  final _cardKey = GlobalKey();

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
    final vh = MediaQuery.sizeOf(context).height;
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
      child: widget.isGrid ? _buildGridCard(context, name) : _buildListCard(context, name),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalH = constraints.maxHeight.isFinite ? constraints.maxHeight : 190.0;
        final totalW = constraints.maxWidth.isFinite ? constraints.maxWidth : 200.0;
        final imageH = totalH - 58;
        final cacheW = (totalW * 2).toInt(); // retina için x2
        final cacheH = (imageH * 2).toInt();
        return Container(
          key: _cardKey,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Üst: resim alanı ────────────────────────────
                SizedBox(
                  width: totalW,
                  height: imageH,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: widget.image,
                    memCacheWidth: cacheW,
                    memCacheHeight: cacheH,
                    placeholder: (_, __) => Container(color: Colors.grey.shade100),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: Image.asset(logoImage, fit: BoxFit.fill),
                    ),
                  ),
                ),

                // ── Alt: beyaz şerit — kategori adı ─────────────
                Expanded(
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontFamily: 'GilroyBold',
                        fontSize: 13,
                        height: 1.3,
                      ),
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
