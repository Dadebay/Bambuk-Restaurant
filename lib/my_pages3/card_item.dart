import 'package:bamboo/options_item.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
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
  CardItem(this.id, this.name_tm, this.name_ru, this.name_en, this.description_tm, this.description_ru, this.description_en, this.image, this.price, this.count, this.rating, this.discount,
      this.discount_price, this.category, this.values,
      {super.key});

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  bool art_empty = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Constants.op_id = widget.id;
        Constants.op_name_tm = widget.name_tm;
        Constants.op_name_ru = widget.name_ru;
        Constants.op_name_ru = widget.name_en;
        Constants.op_description_tm = widget.description_tm;
        Constants.op_description_ru = widget.description_ru;
        Constants.op_description_ru = widget.description_en;
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
                    )));
      },
      child: SizedBox(
          height: 120,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    color: AppColors.light_silver,
                  ),
                  child: const Divider(
                    height: 2,
                    color: AppColors.light_silver,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        widget.image,
                        height: 80,
                        // color: Colors.red,
                        width: 80,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: 80,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  (widget.rating > 0)
                                      ? const Icon(
                                          Icons.star,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        ),
                                  (widget.rating > 1)
                                      ? const Icon(
                                          Icons.star,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        ),
                                  (widget.rating > 2)
                                      ? const Icon(
                                          Icons.star,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        ),
                                  (widget.rating > 3)
                                      ? const Icon(
                                          Icons.star,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        ),
                                  (widget.rating > 4)
                                      ? const Icon(
                                          Icons.star,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        )
                                      : const Icon(
                                          Icons.star_border_outlined,
                                          size: 15,
                                          color: Color.fromARGB(255, 238, 217, 22),
                                        ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 10),
                              // ignore: prefer_const_constructors
                              child: Text(
                                (Provider.of<Which_page>(context).dil != 0) ? widget.name_tm : widget.name_ru,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 10),
                              child: (widget.discount != 0)
                                  ? Row(children: [
                                      Text(
                                        '${widget.discount_price} TMT',
                                        style: const TextStyle(color: Colors.green, fontSize: 15),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${widget.price} TMT',
                                        style: const TextStyle(color: Colors.black, fontSize: 13, decoration: TextDecoration.lineThrough),
                                      ),
                                    ])
                                  : Text(
                                      '${widget.price} TMT',
                                      style: const TextStyle(color: Colors.green, fontSize: 15),
                                    ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.only(right: 10),
                      child: Stack(children: [
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
                            padding: const EdgeInsets.only(right: 4),
                            alignment: Alignment.topRight,
                            child: (Provider.of<Favourite>(context).items[widget.id]?.count == null)
                                ? const Icon(
                                    Icons.favorite_border,
                                    color: Color.fromARGB(255, 218, 44, 32),
                                  )
                                : const Icon(
                                    Icons.favorite,
                                    color: Color.fromARGB(255, 218, 44, 32),
                                  ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                // ignore: prefer_const_constructors
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  color: AppColors.primary,
                                ),
                                child: FloatingActionButton(
                                  heroTag: "minusdak${widget.id}",
                                  hoverElevation: 1.5,
                                  shape: const StadiumBorder(side: BorderSide(color: AppColors.primary, width: 2)),
                                  elevation: 1.5,
                                  backgroundColor: AppColors.primary,
                                  child: Image.asset(
                                    "assets/images/minus.png",
                                    color: Colors.white,
                                    fit: BoxFit.none,
                                    width: 12,
                                    height: 12,
                                  ),
                                  onPressed: () {
                                    widget.count--;
                                    Provider.of<Which_page>(context, listen: false).removeItem(widget.id, widget.count);
                                    setState(() => widget.count);
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                width: 20,
                                // ignore: prefer_const_constructors
                                child: Text(
                                  (Provider.of<Which_page>(context, listen: false).items[widget.id]?.count == null)
                                      ? '0'
                                      : Provider.of<Which_page>(context, listen: false).items[widget.id]!.count.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: AppColors.primary, fontSize: 16),
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                // ignore: prefer_const_constructors
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  color: AppColors.primary,
                                ),
                                child: FloatingActionButton(
                                  heroTag: "plusdak${widget.id}",
                                  hoverElevation: 1.5,
                                  shape: const StadiumBorder(side: BorderSide(color: AppColors.primary, width: 2)),
                                  elevation: 1.5,
                                  backgroundColor: AppColors.primary,
                                  child: Image.asset(
                                    "assets/images/plus.png",
                                    color: Colors.white,
                                    fit: BoxFit.none,
                                    width: 12,
                                    height: 12,
                                  ),
                                  onPressed: () {
                                    widget.count++;
                                    Provider.of<ProvItem>(context, listen: false).addItem(widget.id, widget.name_tm, widget.name_ru, widget.name_en, widget.description_tm, widget.description_ru,
                                        widget.description_en, widget.image, widget.price, widget.count, widget.rating, widget.discount, widget.discount_price, widget.category, widget.values);
                                    setState(() => widget.count);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
