import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/my_orders/about_products.dart';
import 'package:bamboo/my_orders/contorl_my_order.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/models.dart';

import '../../providers/page1provider.dart';

class CardOrders extends StatefulWidget {
  List<orders> product;
  int index;
  CardOrders(this.product, this.index, {super.key});

  @override
  _CardOrdersState createState() => _CardOrdersState();
}

class _CardOrdersState extends State<CardOrders> {
  String s_name_tm = '';
  String s_name_ru = '';
  String s_name_en = '';
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    var card = widget.product[widget.index];

    if (card.status_id == 1) {
      s_name_tm = 'Sargyt barlanýar';
      s_name_ru = 'Заказ в ожидании';
    }
    if (card.status_id == 2) {
      s_name_tm = 'Sargyt tassyklandy';
      s_name_ru = 'Заказ подтвержден';
    }
    if (card.status_id == 3) {
      s_name_tm = 'Sargyt ugradyldy';
      s_name_ru = 'Заказ в пути';
    }
    if (card.status_id == 4) {
      s_name_tm = 'Sargyt gowşuryldy';
      s_name_ru = 'Заказ доставлен';
    }
    if (card.status_id == 5) {
      s_name_tm = 'Sargyt ýatyryldy';
      s_name_ru = 'Заказ отменен';
    }
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              // ignore: prefer_const_constructors
              Text(
                widget.product[widget.index].date.toString(),
                // ignore: prefer_const_constructors
                style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
              ),
              // ignore: prefer_const_constructors
              Text(
                '${card.total_price} TMT',
                // ignore: prefer_const_constructors
                style: TextStyle(color: AppColors.green, fontSize: 12, fontFamily: 'Semi'),
              ),
            ],
          ),
          Text(
            '${Constants.ru_orderNo[prov.dil]} №: ${card.order_no}',
            style: const TextStyle(color: AppColors.silver, fontSize: 14),
          ),
          Text(
            (prov.dil != 0) ? '* $s_name_tm' : '* $s_name_ru',
            style: const TextStyle(color: AppColors.green, fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (() {
                    var towarlar = widget.product[widget.index].my_products;

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutProducts(towarlar)));
                  }),
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      Constants.ru_inform[prov.dil],
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Constants.or_status = card.status_id;
                    Constants.or_track_code = card.order_no;
                    Constants.or_total_price = card.total_price;
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContorlMyOrder()));
                  },
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Text(
                      Constants.ru_control_oder[prov.dil],
                      style: const TextStyle(color: Colors.black),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
