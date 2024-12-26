import 'package:bamboo/options_item.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/constants.dart';

class CartItemsLinear extends StatefulWidget {
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
  CartItemsLinear(this.id, this.name_tm, this.name_ru, this.name_en, this.description_tm, this.description_ru, this.description_en, this.image, this.price, this.count, this.rating, this.discount,
      this.discount_price, this.category, this.values,
      {super.key});

  @override
  _CartItemsLinearState createState() => _CartItemsLinearState();
}

class _CartItemsLinearState extends State<CartItemsLinear> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
            color: const Color.fromRGBO(243, 245, 247, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.image,
                          errorWidget: (context, url, error) => Image.asset(
                            logoImage,
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                    ),
                  ),
                  (widget.discount != 0)
                      ? Container(
                          width: 50,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.circular(16),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(top: 15),
                          child: Text(
                            (Provider.of<Which_page>(context).dil != 0) ? widget.name_tm : widget.name_ru,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: "Semi", fontSize: 14),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: (widget.discount != 0)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.price}TMT',
                                  style: const TextStyle(color: AppColors.light_black, fontSize: 14, decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  '${widget.discount_price}TMT',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontFamily: "Semi",
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              '${widget.price}TMT',
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: "Semi",
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  if (Provider.of<ProvItem>(context, listen: false).items[widget.id]?.count == null) {
                    widget.count++;
                    Provider.of<ProvItem>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru,
                        widget.description_en, widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
                  } else {
                    widget.count = 0;
                    Provider.of<ProvItem>(context, listen: false).removeItem(widget.id, widget.count);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 10, top: 15, left: 5),
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: (Provider.of<ProvItem>(context).items[widget.id]?.count == null) ? AppColors.hover : AppColors.primary,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/man3.svg',
                    color: Colors.white,
                    fit: BoxFit.none,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
              ),

              /*
                  GestureDetector(
                    onTap: (() {
                      if (Provider.of<Favourite>(context, listen: false)
                              .items[widget.id]
                              ?.count ==
                          null) {
                        Provider.of<Favourite>(context, listen: false).addItem(
                            widget.id,
                            widget.name_tm,
                            widget.name_ru,
                            widget.description_tm,
                            widget.description_ru,
                            widget.image,
                            widget.price,
                            widget.count,
                            widget.rating,
                            widget.discount,
                            widget.discount_price,
                            widget.category,
                            widget.values);
                      } else {
                        Provider.of<Favourite>(context, listen: false)
                            .removeItem(widget.id);
                      }
                    }),
                    child: Container(
                      child: (Provider.of<Favourite>(context)
                                  .items[widget.id]
                                  ?.count ==
                              null)
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
                    */
            ],
          ),
        ),
      ),
    );
  }
}
