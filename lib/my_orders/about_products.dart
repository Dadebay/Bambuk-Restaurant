import 'package:bamboo/my_orders/card/card_product_orders.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';
import '../values/models.dart';

class AboutProducts extends StatefulWidget {
  var towarlar;
  AboutProducts(this.towarlar, {super.key});

  @override
  _AboutProductsState createState() => _AboutProductsState();
}

class _AboutProductsState extends State<AboutProducts> {
  List<order_items> product = [];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.towarlar.length; i++) {
      product.add(order_items(
          name_tm: widget.towarlar[i]['name_tm'],
          name_ru: widget.towarlar[i]['name_ru'],
          image: widget.towarlar[i]['image'],
          price: widget.towarlar[i]['price'].toString(),
          count: widget.towarlar[i]['amount'].toString()));
    }

    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: AppColors.appBar_back),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    Constants.ru_orders[Provider.of<Which_page>(context).dil],
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.light_silver,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/back.svg',
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(100),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: product.length,
          itemBuilder: (BuildContext context, int index) {
            return CardProductOrders(product, index);
          }),
    );
  }
}
