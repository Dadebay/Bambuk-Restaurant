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
  CartItems(
    this.id,
    this.name_tm,
    this.name_ru,
    this.name_en,
    this.description_tm,
    this.description_ru,
    this.description_en,
    this.image,
    this.price,
    this.count,
    this.rating,
    this.discount,
    this.discount_price,
    this.category,
    this.values, {
    super.key,
    this.imageHeight = 170,
  });

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
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Image area ─────────────────────────────────────────
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.image,
                      errorWidget: (_, __, ___) => Image.asset(logoImage, fit: BoxFit.cover),
                    ),

                    // Top-right: favourite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
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
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: (Provider.of<Favourite>(context).items[widget.id]?.count == null)
                              ? const Icon(IconlyLight.heart, color: Colors.grey, size: 20)
                              : const Icon(IconlyBold.heart, color: Color(0xFFDA2C20), size: 20),
                        ),
                      ),
                    ),

                    // Top-left: discount badge
                    if (widget.discount != 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '-${widget.discount}%',
                            style: const TextStyle(color: Colors.white, fontFamily: 'Semi', fontSize: 11),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Info area ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product name
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Semi',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Cart button with price
                    _addCartButton(context),
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
    final String priceText = widget.discount != 0 ? '${widget.discount_price.toStringAsFixed(1)} TMT' : '${widget.price.toStringAsFixed(1)} TMT';

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
          borderRadius: BorderRadius.circular(12),
          color: inCart ? AppColors.primary.withOpacity(0.18) : AppColors.primary.withOpacity(0.18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              inCart ? CupertinoIcons.cart_fill_badge_minus : CupertinoIcons.cart,
              color: inCart ? Colors.red.shade400 : Colors.black87,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              inCart ? '✓  $priceText' : priceText,
              style: TextStyle(
                color: inCart ? Colors.red.shade400 : Colors.black87,
                fontFamily: 'Semi',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
