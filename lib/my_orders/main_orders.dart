import 'package:bamboo/my_orders/activ.dart';
import 'package:bamboo/my_orders/disactiv.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../providers/page1settings.dart';

class MainOrders extends StatefulWidget {
  const MainOrders({super.key});

  @override
  _MainOrdersState createState() => _MainOrdersState();
}

class _MainOrdersState extends State<MainOrders> {
  bool aktiw = true;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<PageSettings>(context).page == 1) {
      Navigator.pop(context);
    }
    var prov = Provider.of<Which_page>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                          color: Colors.black,
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
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        aktiw = true;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // ignore: unrelated_type_equality_checks
                        color: (aktiw == true) ? AppColors.primary : AppColors.light_silver,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        Constants.ru_active[Provider.of<Which_page>(context).dil],
                        style: TextStyle(color: (aktiw == true) ? Colors.white : Colors.black, fontFamily: 'Semi'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        aktiw = false;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // ignore: unrelated_type_equality_checks
                        color: (aktiw == false) ? AppColors.primary : AppColors.light_silver,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        Constants.ru_oldOrder[Provider.of<Which_page>(context).dil],
                        style: TextStyle(color: (aktiw == false) ? Colors.white : Colors.black, fontFamily: 'Semi'),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              (aktiw == true) ? const Activ() : const Disactiv(),
            ],
          ),
        ),
      ),
    );
  }
}
