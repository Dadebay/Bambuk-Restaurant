import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/providers/page1settings.dart';
import 'package:bamboo/values/colors.dart';

import '../providers/page1provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

import '../values/models.dart';
import 'cart_items.dart';

class Page1All extends StatefulWidget {
  int type;
  List<products> items;
  Page1All({
    super.key,
    required this.type,
    required this.items,
  });

  @override
  _Page1AllState createState() => _Page1AllState();
}

class _Page1AllState extends State<Page1All> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<PageSettings>(context).page == 1) {
      Navigator.pop(context);
    }
    var prov = Provider.of<Which_page>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
        ),
        title: Text(
          widget.type == 0
              ? Constants.ru_discounts_products[prov.dil]
              : widget.type == 1
                  ? Constants.ru_newBlud[prov.dil]
                  : Constants.ru_hitBlud[prov.dil],
          // ignore: prefer_const_constructors
          style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: gilroySemiBold),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 315, // here set custom Height You Want
            ),
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            primary: false,
            itemCount: widget.items.length,
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
            }),
      ),
    );
  }
}

class UrlLauncher {}
