// ignore_for_file: library_private_types_in_public_api

import 'package:bamboo/options_item.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';

class CardUni extends StatefulWidget {
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
  CardUni(this.id, this.name_tm, this.name_ru, this.name_en, this.description_tm, this.description_ru, this.description_en, this.image, this.price, this.count, this.rating, this.discount,
      this.discount_price, this.category, this.values,
      {super.key});

  @override
  _CardUniState createState() => _CardUniState();
}

class _CardUniState extends State<CardUni> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 295,
      margin: const EdgeInsets.only(left: 5, right: 5),
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 3,
                blurRadius: 3,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (widget.discount != 0)
                      ? Container(
                          width: 50,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '${widget.discount}%',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  width: 150,
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.image,
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/images/check.png',
                        color: Colors.black,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                  height: 48,
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    (Provider.of<Which_page>(context).dil != 0) ? widget.name_tm : widget.name_ru,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: "Semi", fontSize: 14),
                  )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Provider.of<ProvItem>(context, listen: false).items[widget.id]?.count == null) {
                        Provider.of<ProvItem>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru,
                            widget.description_en, widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
                      } else {
                        Provider.of<ProvItem>(context, listen: false).removeItem(widget.id, 0);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                          width: 3,
                          color: AppColors.primary,
                          style: BorderStyle.solid,
                        ),
                        color: (Provider.of<ProvItem>(context).items[widget.id]?.count == null) ? Colors.white : AppColors.primary,
                      ),
                      child: Image.asset(
                        "assets/images/plus.png",
                        color: (Provider.of<ProvItem>(context).items[widget.id]?.count == null) ? AppColors.primary : Colors.white,
                        fit: BoxFit.none,
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: (widget.discount != 0)
                        ? Column(
                            children: [
                              Text(
                                '${widget.price}TMT',
                                style: const TextStyle(color: AppColors.light_black, fontSize: 12, decoration: TextDecoration.lineThrough),
                              ),
                              Text(
                                '${widget.discount_price}TMT',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Semi",
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            '${widget.price}TMT',
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Semi",
                              fontSize: 14,
                            ),
                          ),
                  ),
                  GestureDetector(
                    onTap: (() {
                      if (Provider.of<Favourite>(context, listen: false).items[widget.id]?.count == null) {
                        Provider.of<Favourite>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru,
                            widget.description_en, widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
                      } else {
                        Provider.of<Favourite>(context, listen: false).removeItem(widget.id);
                      }
                    }),
                    child: Container(
                      child: (Provider.of<Favourite>(context).items[widget.id]?.count == null)
                          ? const Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: Color.fromARGB(255, 218, 44, 32),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
