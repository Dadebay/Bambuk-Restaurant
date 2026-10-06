import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

import 'card/card_orders.dart';

class Disactiv extends StatefulWidget {
  const Disactiv({super.key});

  @override
  _DisactivState createState() => _DisactivState();
}

class _DisactivState extends State<Disactiv> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: Constants.dis_activ.length,
        itemBuilder: (BuildContext context, int index) {
          return CardOrders(Constants.dis_activ, index);
        });
  }
}
