import 'package:bamboo/my_pages/page1_all.dart';
import 'package:bamboo/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/my_pages/cart_items.dart';

// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import '../providers/page1provider.dart';
import '../values/models.dart';

// ignore: must_be_immutable
class MainVisibles extends StatefulWidget {
  int type;
  List<products> items;
  MainVisibles({
    super.key,
    required this.type,
    required this.items,
  });

  @override
  _MainVisiblesState createState() => _MainVisiblesState();
}

class _MainVisiblesState extends State<MainVisibles> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Page1All(
                          type: widget.type,
                          items: widget.items,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.type == 0
                      ? Constants.ru_discounts_products[prov.dil]
                      : widget.type == 1
                          ? Constants.ru_newBlud[prov.dil]
                          : Constants.ru_hitBlud[prov.dil],
                  style: const TextStyle(fontSize: 18, fontFamily: "Semi", color: Colors.black),
                ),
                const Icon(
                  IconlyLight.arrow_right_circle,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
        Container(
          height: 315,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.items.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return CartItems(
                  widget.items[index].id,
                  widget.items[index].name_tm,
                  widget.items[index].name_ru,
                  widget.items[index].name_en,
                  widget.items[index].description_tm,
                  widget.items[index].description_ru,
                  widget.items[index].description_en,
                  widget.items[index].image,
                  widget.items[index].price,
                  widget.items[index].count,
                  widget.items[index].rating,
                  widget.items[index].discount,
                  widget.items[index].discount_price,
                  widget.items[index].category,
                  widget.items[index].values);
            },
          ),
        ),
      ],
    );
  }
}
