import 'dart:convert';

import 'package:bamboo/my_orders/card/card_orders.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../values/models.dart';

class Activ extends StatefulWidget {
  const Activ({super.key});

  @override
  _ActivState createState() => _ActivState();
}

class _ActivState extends State<Activ> {
  int page = 0;
  bool loading = false;
  int k = 0;

  List<orders> product = [];

  Future getTime() async {
    page++;
    loading = false;
    Map<String, String> header = {'Authorization': 'Bearer ${Constants.token}'};
    var response3 = await http.get(Uri.https(Constants.api, '/api/v1/users/me/orders/'), headers: header);
    var mitem = json.decode(utf8.decode(response3.bodyBytes))['data'];
    Constants.dis_activ.clear();
    product.clear();
    if (mitem.length == 0) loading = true;
    for (int i = 0; i < mitem.length; i++) {
      if (mitem[i]['status']['id'] == 1 || mitem[i]['status']['id'] == 2 || mitem[i]['st6060atus']['id'] == 3) {
        product.add(orders(
            id: mitem[i]['id'],
            date: mitem[i]['created_at'],
            status_id: mitem[i]['status']['id'],
            status: mitem[i]['status']['name_tm'],
            status_ru: mitem[i]['status']['name_ru'],
            order_no: mitem[i]['track_code'],
            my_products: mitem[i]['products'],
            total_price: mitem[i]['total_price'].toString()));
      } else {
        Constants.dis_activ.add(orders(
            id: mitem[i]['id'],
            date: mitem[i]['created_at'],
            status_id: mitem[i]['status']['id'],
            status: mitem[i]['status']['name_tm'],
            status_ru: mitem[i]['status']['name_ru'],
            order_no: mitem[i]['track_code'],
            my_products: mitem[i]['products'],
            total_price: mitem[i]['total_price'].toString()));
      }
    }
    setState(() {
      k = 1;
    });
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          return CardOrders(product, index);
        });
  }
}
