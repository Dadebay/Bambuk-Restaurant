import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  CartItems(this.id, this.name_tm, this.name_ru, this.name_en, this.description_tm, this.description_ru, this.description_en, this.image, this.price, this.count, this.rating, this.discount,
      this.discount_price, this.category, this.values,
      {super.key});

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    print(widget.discount);
    return GestureDetector(
      onTap: () {
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
          MaterialPageRoute(
              builder: (context) => OptionsItem(
                    image: widget.image,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 3, blurRadius: 3)],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  image(),
                  favButton(context),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          Provider.of<Which_page>(context).dil == 1
                              ? widget.name_tm
                              : Provider.of<Which_page>(context).dil == 0
                                  ? widget.name_ru
                                  : widget.name_en,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: "Semi", fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    addCartButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addCartButton(BuildContext context) {
    bool addCart = (Provider.of<ProvItem>(context).items[widget.id]?.count == null);
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {
          if (Provider.of<ProvItem>(context, listen: false).items[widget.id]?.count == null) {
            widget.count++;
            Provider.of<ProvItem>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru, widget.description_en,
                widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
          } else {
            widget.count = 0;
            Provider.of<ProvItem>(context, listen: false).removeItem(widget.id, widget.count);
          }
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: addCart ? AppColors.hover : AppColors.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                addCart ? CupertinoIcons.cart : CupertinoIcons.cart_fill,
                color: addCart ? Colors.black : Colors.white,
              ),
              Container(
                margin: const EdgeInsets.only(left: 15),
                alignment: Alignment.center,
                child: (widget.discount != 0)
                    ? Column(
                        children: [
                          Text(
                            '${widget.price} TMT',
                            style: const TextStyle(color: Colors.black, fontSize: 14, decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            '${widget.discount_price} TMT',
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Semi",
                              fontSize: 1,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '${widget.price} TMT',
                        style: TextStyle(
                          color: addCart ? Colors.black : Colors.white,
                          fontFamily: "Semi",
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: widget.image,
        errorWidget: (context, url, error) => Image.asset(
          logoImage,
          width: 150,
          height: 150,
        ),
      ),
    );
  }

  Widget favButton(BuildContext context) {
    return Positioned(
      right: 10,
      top: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.discount != 0)
              ? Container(
                  width: 50,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${widget.discount}%',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : Container(),
          GestureDetector(
            onTap: (() {
              if (Provider.of<Favourite>(context, listen: false).items[widget.id]?.count == null) {
                Provider.of<Favourite>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru, widget.description_en,
                    widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
              } else {
                Provider.of<Favourite>(context, listen: false).removeItem(widget.id);
              }
            }),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: (Provider.of<Favourite>(context).items[widget.id]?.count == null)
                  ? const Icon(
                      Icons.favorite_border,
                      color: AppColors.primary,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 218, 44, 32),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
