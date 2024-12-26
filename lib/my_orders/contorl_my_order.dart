import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

import '../providers/page1provider.dart';
import '../providers/page1settings.dart';
import '../values/colors.dart';

class ContorlMyOrder extends StatefulWidget {
  const ContorlMyOrder({super.key});

  @override
  _ContorlMyOrderState createState() => _ContorlMyOrderState();
}

class _ContorlMyOrderState extends State<ContorlMyOrder> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<PageSettings>(context).page == 1) {
      Navigator.pop(context);
    }
    var prov = Provider.of<Which_page>(context);
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 55,
            margin: const EdgeInsets.only(top: 10),
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
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: (() {
                    Provider.of<PageSettings>(context, listen: false).set_page0();
                    Navigator.pop(context);
                  }),
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
                      color: Colors.black,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),

                // ignore: prefer_const_constructors
                Text(
                  Constants.ru_control_oder[prov.dil],
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
      body: ListView(
        children: [
          Container(
            height: 55,
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            padding: const EdgeInsets.only(right: 5, left: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
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
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Expanded(
                  child: Text(
                    '${Constants.ru_orderNo} №: ${Constants.or_track_code}',
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Semi",
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${Constants.ru_fullJem} : ${Constants.or_total_price}TMT',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          /**
          Container(
            height: 55,
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            padding: const EdgeInsets.only(right: 5, left: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
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
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.green,
                ),
                Text(
                  'Azatlyk Saheri',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ), */
          Container(
            height: 55,
            margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
            padding: const EdgeInsets.only(right: 5, left: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
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
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Container(
                  height: 35,
                  width: 35,
                  margin: const EdgeInsets.only(right: 20),
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                    color: AppColors.silver,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      // ignore: prefer_const_constructors
                      Text(
                        Constants.name,
                        // ignore: prefer_const_constructors
                        style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(Constants.email),
                    ],
                  ),
                ),
              ],
            ),
          ),
          (Constants.or_status > 0)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 40, top: 20),
                  child: Row(children: [
                    Image.asset('assets/images/accept.png', width: 30, height: 30),
                    const SizedBox(width: 5),
                    Text((Provider.of<Which_page>(context).dil != 0) ? 'Sargyt barlanýar' : 'Заказ в ожидании', style: const TextStyle(fontFamily: 'Semi')),
                  ]),
                )
              : Container(),
          (Constants.or_status > 1)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 54, top: 2),
                  child: Image.asset('assets/images/order_stick.png'),
                )
              : Container(),
          (Constants.or_status > 1)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 40, top: 2),
                  child: Row(children: [
                    Image.asset('assets/images/accept.png', width: 30, height: 30),
                    const SizedBox(width: 5),
                    Text((Provider.of<Which_page>(context).dil != 0) ? 'Sargyt tassyklandy' : 'Заказ подтвержден', style: const TextStyle(fontFamily: 'Semi')),
                  ]),
                )
              : Container(),
          (Constants.or_status > 2)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 54, top: 2),
                  child: Image.asset('assets/images/order_stick.png'),
                )
              : Container(),
          (Constants.or_status > 2)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 40, top: 2),
                  child: Row(children: [
                    Image.asset('assets/images/accept.png', width: 30, height: 30),
                    const SizedBox(width: 5),
                    Text((Provider.of<Which_page>(context).dil != 0) ? 'Sargyt ugradyldy' : 'Заказ в пути', style: const TextStyle(fontFamily: 'Semi')),
                  ]),
                )
              : Container(),
          (Constants.or_status > 3)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 54, top: 2),
                  child: Image.asset('assets/images/order_stick.png'),
                )
              : Container(),
          (Constants.or_status > 3)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 40, top: 2),
                  child: Row(children: [
                    Image.asset('assets/images/accept.png', width: 30, height: 30),
                    const SizedBox(width: 5),
                    Text((Provider.of<Which_page>(context).dil != 0) ? 'Sargyt gowşuryldy' : 'Заказ доставлен', style: const TextStyle(fontFamily: 'Semi')),
                  ]),
                )
              : Container(),
          (Constants.or_status > 4)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 54, top: 2),
                  child: Image.asset('assets/images/order_stick.png'),
                )
              : Container(),
          (Constants.or_status > 4)
              ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 35, top: 2),
                  child: Row(children: [
                    Image.asset('assets/images/declined.png', width: 40, height: 40),
                    const SizedBox(width: 5),
                    Text((Provider.of<Which_page>(context).dil != 0) ? 'Sargyt ýatyryldy' : 'Заказ oтsменен', style: const TextStyle(fontFamily: 'Semi')),
                  ]),
                )
              : Container(),
        ],
      ),
    );
  }
}
