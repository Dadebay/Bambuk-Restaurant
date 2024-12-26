import 'dart:convert';

import 'package:bamboo/my_pages3/card_item.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MyCatItems extends StatefulWidget {
  const MyCatItems({super.key});

  @override
  _MyCatItemsState createState() => _MyCatItemsState();
}

class _MyCatItemsState extends State<MyCatItems> {
  int page = 0;
  bool loading = false;

  List<products> product = [];
  Future getTime() async {
    page++;
    loading = false;
    var headers = {"limit": 15};
    var response3 = await http.get(Uri.https(Constants.api, '/api/v1/products/', {'limit': '15', 'page': '$page', 'category': Constants.op_category}));
    var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
    if (mitem.length == 0) loading = true;
    for (int i = 0; i < mitem.length; i++) {
      // ignore: curly_braces_in_flow_control_structures
      product.add(products(
          id: mitem[i]['id'],
          name_tm: mitem[i]['name_tm'] ?? '',
          name_ru: mitem[i]['name_ru'] ?? '',
          name_en: mitem[i]['name_en'] ?? '',
          description_tm: mitem[i]['descrioption_tm'] ?? '',
          description_ru: mitem[i]['descrioption_ru'] ?? '',
          description_en: mitem[i]['descrioption_en'] ?? '',
          image: mitem[i]['image'],
          price: double.parse(mitem[i]['price']),
          count: mitem[i]['count'],
          rating: double.parse(mitem[i]['rating']),
          discount: mitem[i]['discount'],
          discount_price: double.parse(mitem[i]['discounted_price'] ?? "0.00"),
          category: mitem[i]['category']['id'].toString(),
          values: mitem[i]['values']));
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
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 55,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    Navigator.pop(context);
                  }),
                  child: Container(
                    height: 55,
                    width: 55,
                    color: const Color.fromARGB(0, 255, 255, 255),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // ignore: prefer_const_constructors
                Text(
                  Constants.ru_category[Provider.of<Which_page>(context).dil],
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(100),
      ),
      body: ListView.builder(
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
          }),
    );
  }
}
