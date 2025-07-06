import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../values/models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../my_pages3/card_item.dart';
import '../../providers/page1provider.dart';
import '../../providers/page1settings.dart';
import '../../values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

import '../cart_items.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late final TextEditingController _importo;

  @override
  void initState() {
    super.initState();
    _importo = TextEditingController()
      ..addListener(() {
        setState(() {
          getTime();
        });
      });
  }

  List<products> product = [];

  Future getTime() async {
    product = [];
    var response3 = await http.get(Uri.https(Constants.api, '/api/v1/products', {'keyword': _importo.text}));
    var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
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
          discount_price: double.parse(mitem[i]['discounted_price'] == null ? "0.00" : mitem[i]['discounted_price'].toString()),
          category: mitem[i]['category']['id'].toString(),
          values: mitem[i]['values']));
    }
    setState(() {});
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.appBar_back,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: (() {
                    Provider.of<PageSettings>(context, listen: false).set_page0();
                    Navigator.pop(context);
                  }),
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(left: 5, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.light_silver,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/back.svg',
                      color: Colors.black,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),
                // ignore: prefer_const_constructors
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5, right: 15),
                    decoration: BoxDecoration(
                      color: AppColors.light_silver,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 5),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              textAlign: TextAlign.start,
                              controller: _importo,
                              autofocus: true,
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                                ),
                                // ignore: prefer_const_constructors
                                labelStyle: TextStyle(fontSize: 10, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 15),
                          child: SvgPicture.asset(
                            'assets/images/search.svg',
                            color: AppColors.primary,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: (product.isEmpty)
          ? const Text('')
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 315, // here set custom Height You Want
              ),
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              primary: false,
              itemCount: product.length,
              itemBuilder: (BuildContext context, int index) {
                return CartItems(
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
