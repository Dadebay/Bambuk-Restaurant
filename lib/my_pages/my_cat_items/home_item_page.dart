import 'package:flutter/material.dart';

import 'package:bamboo/my_pages/cart_items.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/models.dart';

class HomeItemPage extends StatefulWidget {
  int id;
  HomeItemPage(this.id, {super.key});

  @override
  _HomeItemPageState createState() => _HomeItemPageState();
}

class _HomeItemPageState extends State<HomeItemPage> {
  List<products> product = [];

  Future getTime() async {
    var m = Constants.home_data[widget.id.toString()];
    for (int i = 0; i < m.length; i++) {
      product.add(products(
          id: m[i]['id'],
          name_tm: m[i]['name_tm'] ?? '',
          name_ru: m[i]['name_ru'] ?? '',
          name_en: m[i]['name_en'] ?? '',
          description_tm: m[i]['descrioption_tm'] ?? '',
          description_ru: m[i]['descrioption_ru'] ?? '',
          description_en: m[i]['descrioption_en'] ?? '',
          image: m[i]['image'],
          price: double.parse(m[i]['price']),
          count: m[i]['count'],
          rating: double.parse(m[i]['rating']),
          discount: m[i]['discount'],
          discount_price: (m[i]['discounted_price'] != null) ? double.parse(m[i]['discounted_price']) : 0.00,
          category: m[i]['category']['id'].toString(),
          values: m[i]['values']));
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
    return Container(
      height: 315,
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: product.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
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
        },
      ),
    );
  }
}

/*
 CartItems(
                product[index].id,
                product[index].name_tm,
                product[index].name_ru,
                product[index].description_tm,
                product[index].description_ru,
                product[index].image,
                product[index].price,
                product[index].count,
                product[index].rating,
                product[index].discount,
                product[index].discount_price,
        );
        */