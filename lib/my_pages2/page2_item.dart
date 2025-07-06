import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:bamboo/my_pages3/card_item.dart';
import 'package:bamboo/providers/page1settings.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/models.dart';

class Page2Item extends StatefulWidget {
  const Page2Item({super.key});

  @override
  _Page2ItemState createState() => _Page2ItemState();
}

class _Page2ItemState extends State<Page2Item> {
  int page = 0;
  bool loading = false;

  List<products> product = [];
  Future getTime() async {
    page++;
    loading = false;

    if (page == 1) {
      for (int i = 0; i < Constants.product.length; i++) {
        product.add(products(
            id: Constants.product[i].id,
            name_tm: Constants.product[i].name_tm,
            name_ru: Constants.product[i].name_ru,
            name_en: Constants.product[i].name_en,
            description_tm: Constants.product[i].description_tm,
            description_ru: Constants.product[i].description_ru,
            description_en: Constants.product[i].description_en,
            image: Constants.product[i].image,
            price: Constants.product[i].price,
            count: Constants.product[i].count,
            rating: Constants.product[i].rating,
            discount: Constants.product[i].discount,
            discount_price: Constants.product[i].discount_price,
            category: Constants.product[i].category,
            values: Constants.product[i].values));
      }
    } else {
      var response3 = await http.get(Uri.https(Constants.api, '/api/v1/products/', {'limit': '10', 'daily': '1', 'page': '$page'}));
      var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
      if (mitem.length == 0) loading = true;
      for (int i = 0; i < mitem.length; i++) {
        // ignore: curly_braces_in_flow_control_structures
        product.add(products(
            id: mitem[i]['id'],
            name_tm: mitem[i]['name_tm'] ?? '',
            name_ru: mitem[i]['name_ru'] ?? '',
            name_en: mitem[i]['name_en'] ?? '',
            description_tm: mitem[i]['description_tm'] ?? '',
            description_ru: mitem[i]['description_ru'] ?? '',
            description_en: mitem[i]['description_en'] ?? '',
            image: mitem[i]['image'],
            price: double.parse(mitem[i]['price']),
            count: mitem[i]['count'],
            rating: double.parse(mitem[i]['rating']),
            discount: mitem[i]['discount'],
            discount_price: double.parse(mitem[i]['discounted_price'] ?? "0.00"),
            category: mitem[i]['category']['id'].toString(),
            values: mitem[i]['values']));
      }
    }

    setState(() {});
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<PageSettings>(context) == 1) Navigator.pop(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == product.length - 1) {
            if (loading == false) {
              loading = true;
              getTime();
            }
          }
          return CardItem(
              product[index].id,
              product[index].name_tm,
              product[index].name_ru,
              product[index].name_en,
              product[index].description_tm,
              product[index].description_ru,
              product[index].description_en,
              product[index].image,
              product[index].price,
              product[index].count,
              product[index].rating,
              product[index].discount,
              product[index].discount_price,
              product[index].category,
              product[index].values);
        });
  }
}
