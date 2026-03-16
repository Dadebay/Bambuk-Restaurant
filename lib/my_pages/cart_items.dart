import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../options_item.dart';
import '../providers/favourite.dart';
import '../providers/page1provider.dart';
import '../providers/provider_items.dart';
import '../values/colors.dart';

class CartItems extends StatefulWidget {
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
  final double imageHeight;
  CartItems(this.id, this.name_tm, this.name_ru, this.name_en, this.description_tm, this.description_ru, this.description_en, this.image, this.price, this.count, this.rating, this.discount,
      this.discount_price, this.category, this.values,
      {super.key, this.imageHeight = 268});

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OptionsItem(image: widget.image)),
    );
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
      onTap: _navigateToDetail,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        width: 190,
        height: widget.imageHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 14, offset: const Offset(0, 4)),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Ürün resmi (tam arka plan) ─────────────────────────────
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: widget.image,
                errorWidget: (context, url, error) => Image.asset(
                  logoImage,
                  fit: BoxFit.cover,
                ),
              ),

              // ── Alt koyu gradient gölge ────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 155,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.88), Colors.transparent],
                    ),
                  ),
                ),
              ),

              // ── Ürün adı (gradient üstünde) ────────────────────────────
              Positioned(
                left: 10,
                right: 10,
                bottom: 66,
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Semi',
                    fontSize: 13,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                  ),
                ),
              ),

              // ── Sepete ekle butonu (en altta overlay) ──────────────────
              Positioned(
                left: 8,
                right: 8,
                bottom: 10,
                child: _addCartButton(context),
              ),

              // ── Üst satır: indirim badge + favori butonu ───────────────
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.discount != 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${widget.discount}%',
                          style: const TextStyle(color: Colors.white, fontFamily: 'Semi', fontSize: 11),
                        ),
                      ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (Provider.of<Favourite>(context, listen: false).items[widget.id]?.count == null) {
                          Provider.of<Favourite>(context, listen: false).addItem(
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
                        } else {
                          Provider.of<Favourite>(context, listen: false).removeItem(widget.id);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: (Provider.of<Favourite>(context).items[widget.id]?.count == null)
                            ? const Icon(IconlyLight.heart, color: AppColors.primary, size: 18)
                            : const Icon(IconlyBold.heart, color: Color.fromARGB(255, 218, 44, 32), size: 18),
                      ),
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

  Widget _addCartButton(BuildContext context) {
    final bool inCart = Provider.of<ProvItem>(context).items[widget.id]?.count != null;
    return GestureDetector(
      onTap: () {
        if (Provider.of<ProvItem>(context, listen: false).items[widget.id]?.count == null) {
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
        } else {
          widget.count = 0;
          Provider.of<ProvItem>(context, listen: false).removeItem(widget.id, widget.count);
        }
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: inCart ? Colors.white : AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: inCart ? Colors.transparent : AppColors.primary.withOpacity(0.45),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              inCart ? CupertinoIcons.cart_fill : CupertinoIcons.cart,
              color: inCart ? AppColors.primary : Colors.white,
              size: 18,
            ),
            const SizedBox(width: 6),
            if (widget.discount != 0) ...[
              Text(
                '${widget.price}',
                style: TextStyle(
                  color: inCart ? Colors.grey : Colors.white.withOpacity(0.7),
                  fontSize: 11,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.discount_price} T',
                style: TextStyle(
                  color: inCart ? AppColors.primary : Colors.white,
                  fontFamily: 'Semi',
                  fontSize: 13,
                ),
              ),
            ] else
              Text(
                '${widget.price} TMT',
                style: TextStyle(
                  color: inCart ? AppColors.primary : Colors.white,
                  fontFamily: 'Semi',
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
