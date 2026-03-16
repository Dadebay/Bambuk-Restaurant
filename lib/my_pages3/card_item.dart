import 'package:bamboo/options_item.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../providers/provider_items.dart';

class CardItem extends StatefulWidget {
  int id;
  String name_tm;
  String name_ru;
  String name_en;
  String description_tm;
  String description_ru;
  String description_en;
  String image;
  double price;
  int count;
  double rating;
  int discount;
  double discount_price;
  String category;
  var values;

  final ScrollController? scrollController;
  final bool isGrid;
  CardItem(this.id, this.name_tm, this.name_ru, this.name_en, this.description_tm, this.description_ru, this.description_en, this.image, this.price, this.count, this.rating, this.discount,
      this.discount_price, this.category, this.values,
      {super.key, this.scrollController, this.isGrid = false});

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  final _imageKey = GlobalKey();

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

  void _navigateToDetail() {
    Constants.op_id = widget.id;
    Constants.op_name_tm = widget.name_tm;
    Constants.op_name_ru = widget.name_ru;
    Constants.op_name_en = widget.name_en;
    Constants.op_description_tm = widget.description_tm;
    Constants.op_description_ru = widget.description_ru;
    Constants.op_description_en = widget.description_en;
    Constants.op_image = widget.image;
    Constants.op_price = widget.price;
    Constants.op_count = widget.count;
    Constants.op_rating = widget.rating;
    Constants.op_discount = widget.discount;
    Constants.op_discount_price = widget.discount_price;
    Constants.op_category = widget.category;
    Constants.op_values = widget.values;
    Navigator.push(context, MaterialPageRoute(builder: (_) => OptionsItem(image: widget.image)));
  }

  @override
  Widget build(BuildContext context) {
    final int dil = Provider.of<Which_page>(context).dil;
    final String name = dil == 0
        ? widget.name_ru
        : dil == 1
            ? widget.name_tm
            : widget.name_en;
    final int cartCount = Provider.of<ProvItem>(context).items[widget.id]?.count ?? 0;
    final bool isFav = Provider.of<Favourite>(context).items[widget.id]?.count != null;

    if (widget.isGrid) {
      return _buildGridCard(context, name, cartCount, isFav);
    }

    return GestureDetector(
      onTap: _navigateToDetail,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 22,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Parallax image ────────────────────────────────────────
              SizedBox(
                key: _imageKey,
                height: 190,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageUrl: widget.image,
                      width: double.infinity,
                      height: 190,
                      placeholder: (_, __) => Container(color: Colors.grey.shade100),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 44, color: Colors.grey),
                      ),
                    ),
                    // Bottom gradient
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
                            colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                          ),
                        ),
                      ),
                    ),
                    // Discount badge — top left
                    if (widget.discount != 0)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '-${widget.discount}%',
                            style: const TextStyle(color: Colors.white, fontFamily: 'Semi', fontSize: 12),
                          ),
                        ),
                      ),
                    // Favourite button — top right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          isFav
                              ? Provider.of<Favourite>(context, listen: false).removeItem(widget.id)
                              : Provider.of<Favourite>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru,
                                  widget.description_en, widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? const Color.fromARGB(255, 218, 44, 32) : AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Star rating — bottom left
                    Positioned(
                      bottom: 10,
                      left: 12,
                      child: Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < widget.rating.round() ? CupertinoIcons.star_fill : CupertinoIcons.star,
                            size: 13,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info row ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Name + price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'GilroyBold',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (widget.discount != 0) ...[
                            Text(
                              '${widget.price} TMT',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '${widget.discount_price} TMT',
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'Semi',
                                fontSize: 15,
                              ),
                            ),
                          ] else
                            Text(
                              '${widget.price} TMT',
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'Semi',
                                fontSize: 15,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // +/- counter
                    _CartCounter(
                      count: cartCount,
                      onAdd: () {
                        widget.count++;
                        Provider.of<ProvItem>(context, listen: false).addItem(
                          widget.id,
                          widget.name_tm,
                          widget.name_ru,
                          widget.name_en,
                          widget.description_tm,
                          widget.description_ru,
                          widget.description_en,
                          widget.image,
                          widget.price,
                          widget.count,
                          widget.rating,
                          widget.discount,
                          widget.discount_price,
                          widget.category,
                          widget.values,
                        );
                        setState(() {});
                      },
                      onRemove: () {
                        widget.count--;
                        Provider.of<Which_page>(context, listen: false).removeItem(widget.id, widget.count);
                        setState(() {});
                      },
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

  Widget _buildGridCard(BuildContext context, String name, int cartCount, bool isFav) {
    return GestureDetector(
      onTap: _navigateToDetail,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.image,
                      placeholder: (_, __) => Container(color: Colors.grey.shade100),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 32, color: Colors.grey),
                      ),
                    ),
                    if (widget.discount != 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                          child: Text('-${widget.discount}%', style: const TextStyle(color: Colors.white, fontFamily: 'Semi', fontSize: 10)),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          isFav
                              ? Provider.of<Favourite>(context, listen: false).removeItem(widget.id)
                              : Provider.of<Favourite>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru,
                                  widget.description_en, widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? const Color.fromARGB(255, 218, 44, 32) : AppColors.primary,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Info
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'GilroyBold', fontSize: 13, color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    if (widget.discount != 0) ...[
                      Text('${widget.price} TMT', style: const TextStyle(color: Colors.grey, fontSize: 11, decoration: TextDecoration.lineThrough)),
                      Text('${widget.discount_price} TMT', style: const TextStyle(color: Colors.green, fontFamily: 'Semi', fontSize: 13)),
                    ] else
                      Text('${widget.price} TMT', style: const TextStyle(color: Colors.green, fontFamily: 'Semi', fontSize: 13)),
                    const SizedBox(height: 8),
                    _CartCounter(
                      count: cartCount,
                      onAdd: () {
                        widget.count++;
                        Provider.of<ProvItem>(context, listen: false).addItem(
                          widget.id,
                          widget.name_tm,
                          widget.name_ru,
                          widget.name_en,
                          widget.description_tm,
                          widget.description_ru,
                          widget.description_en,
                          widget.image,
                          widget.price,
                          widget.count,
                          widget.rating,
                          widget.discount,
                          widget.discount_price,
                          widget.category,
                          widget.values,
                        );
                        setState(() {});
                      },
                      onRemove: () {
                        widget.count--;
                        Provider.of<Which_page>(context, listen: false).removeItem(widget.id, widget.count);
                        setState(() {});
                      },
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
}

// ── Compact +/- counter ───────────────────────────────────────────────────────
class _CartCounter extends StatelessWidget {
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _CartCounter({required this.count, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Btn(icon: CupertinoIcons.minus, onTap: onRemove),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primary,
                fontFamily: 'Semi',
                fontSize: 16,
              ),
            ),
          ),
          _Btn(icon: CupertinoIcons.plus, onTap: onAdd),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 17),
      ),
    );
  }
}
