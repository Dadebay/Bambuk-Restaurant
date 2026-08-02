import 'package:bamboo/my_orders/card/card_product_orders.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/models.dart';

class AboutProducts extends StatefulWidget {
  final dynamic towarlar;
  const AboutProducts(this.towarlar, {super.key});

  @override
  _AboutProductsState createState() => _AboutProductsState();
}

class _AboutProductsState extends State<AboutProducts> {
  List<order_items> product = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.towarlar.length; i++) {
      product.add(order_items(
          name_tm: widget.towarlar[i]['name_tm'],
          name_ru: widget.towarlar[i]['name_ru'],
          image: widget.towarlar[i]['image'],
          price: widget.towarlar[i]['price'].toString(),
          count: widget.towarlar[i]['amount'].toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dil = Provider.of<Which_page>(context).dil;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
        ),
        title: Text(
          Constants.ru_orders[dil],
          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEEE)),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        physics: const BouncingScrollPhysics(),
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          return CardProductOrders(product, index);
        },
      ),
    );
  }
}
