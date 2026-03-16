import 'package:bamboo/options_item.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/values/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';

class KarzinaCard extends StatefulWidget {
  final int id;
  final String nameTm;
  final String nameRu;
  final String nameEn;
  final String descriptionTm;
  final String descriptionRu;
  final String descriptionEn;
  final String image;
  final double price;
  final int count;
  final double rating;
  final int discount;
  final double discountPrice;
  final String category;
  final dynamic values;

  KarzinaCard(
    this.id,
    this.nameTm,
    this.nameRu,
    this.nameEn,
    this.descriptionTm,
    this.descriptionRu,
    this.descriptionEn,
    this.image,
    this.price,
    this.count,
    this.rating,
    this.discount,
    this.discountPrice,
    this.category,
    this.values, {
    super.key,
  });

  @override
  _KarzinaCardState createState() => _KarzinaCardState();
}

class _KarzinaCardState extends State<KarzinaCard> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _count = widget.count;
  }

  @override
  void didUpdateWidget(covariant KarzinaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _count = widget.count;
    }
  }

  String _getProductName(BuildContext context) {
    final language = Provider.of<Which_page>(context).dil;
    switch (language) {
      case 1:
        return widget.nameTm;
      case 0:
        return widget.nameRu;
      default:
        return widget.nameEn;
    }
  }

  void _navigateToOptionsItem(BuildContext context) {
    constants.op_id = widget.id;
    constants.op_name_tm = widget.nameTm;
    constants.op_name_ru = widget.nameRu;
    constants.op_name_en = widget.nameEn;
    constants.op_description_tm = widget.descriptionTm;
    constants.op_description_ru = widget.descriptionRu;
    constants.op_description_en = widget.descriptionEn;
    constants.op_image = widget.image;
    constants.op_price = widget.price;
    constants.op_count = widget.count;
    constants.op_rating = widget.rating;
    constants.op_discount = widget.discount;
    constants.op_discount_price = widget.discountPrice;
    constants.op_category = widget.category;
    constants.op_values = widget.values;
    Navigator.push(context, MaterialPageRoute(builder: (_) => OptionsItem(image: widget.image)));
  }

  void _decreaseCount(BuildContext context) {
    if (_count > 0) {
      setState(() => _count--);
      Provider.of<ProvItem>(context, listen: false).removeItem(widget.id, _count);
    }
  }

  void _increaseCount(BuildContext context) {
    setState(() => _count++);
    Provider.of<ProvItem>(context, listen: false).addItem(widget.id, widget.nameTm, widget.nameRu, widget.nameEn, widget.descriptionTm, widget.descriptionRu, widget.descriptionEn, widget.image,
        widget.price, _count, widget.rating, widget.discount, widget.discountPrice, widget.category, widget.values);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = Provider.of<ProvItem>(context).items[widget.id]?.count ?? _count;

    return Slidable(
      key: ValueKey(widget.id),
      endActionPane: ActionPane(
        extentRatio: 0.22,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(onDismissed: () {
          Provider.of<ProvItem>(context, listen: false).removeItem2(widget.id);
        }),
        children: [
          SlidableAction(
            onPressed: (_) {
              Provider.of<ProvItem>(context, listen: false).removeItem2(widget.id);
            },
            backgroundColor: const Color(0xFFFF3B30),
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(18)),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _navigateToOptionsItem(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Color(0x0E000000), blurRadius: 16, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Image ──
              Container(
                width: 95,
                height: 95,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7FA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        width: 95,
                        height: 95,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => Container(
                          color: const Color(0xFFF6F7FA),
                          child: const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Center(
                          child: Image.asset(logoImage, width: 60, height: 60, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    // discount badge
                    if (widget.discount != 0)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF3B30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${widget.discount}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: gilroyBold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Name + Price ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getProductName(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: gilroyBold,
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (widget.discount != 0) ...[
                        Text(
                          '${widget.discountPrice} TMT',
                          style: const TextStyle(
                            fontFamily: gilroyBold,
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '${widget.price} TMT',
                          style: const TextStyle(
                            fontFamily: gilroyRegular,
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ] else
                        Text(
                          '${widget.price} TMT',
                          style: const TextStyle(
                            fontFamily: gilroyBold,
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Counter ──
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _counterBtn(
                      icon: Icons.add_rounded,
                      color: Colors.white,
                      bg: AppColors.primary,
                      onTap: () => _increaseCount(context),
                      heroTag: 'plus_${widget.id}',
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$itemCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: gilroyBold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _counterBtn(
                      icon: Icons.remove_rounded,
                      color: Colors.black87,
                      bg: const Color(0xFFF0F0F0),
                      onTap: () => _decreaseCount(context),
                      heroTag: 'minus_${widget.id}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _counterBtn({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
    required String heroTag,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: FloatingActionButton(
        heroTag: heroTag,
        elevation: 0,
        hoverElevation: 0,
        backgroundColor: bg,
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
