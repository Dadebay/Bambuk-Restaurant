import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_pages2/sub_cat.dart';
import '../providers/page1provider.dart';

class Harytlar extends StatefulWidget {
  int id;
  String name_tm;
  String name_ru;
  var children;
  Harytlar(this.id, this.name_tm, this.name_ru, this.children, {super.key});

  @override
  _HarytlarState createState() => _HarytlarState();
}

class _HarytlarState extends State<Harytlar> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    return Container(
        height: 30,
        margin: const EdgeInsets.only(right: 15, left: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    (prov.dil != 0) ? widget.name_tm : widget.name_ru,
                    style: const TextStyle(fontSize: 18, fontFamily: "Semi", color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Constants.children = widget.children;
                    Constants.myCatID = widget.id;
                    Constants.myCatName = (Provider.of<Which_page>(context, listen: false).dil != 0) ? widget.name_tm : widget.name_ru;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SubCat()));
                  },
                  child: Text(
                    Constants.ru_showAll[prov.dil],
                    style: const TextStyle(fontSize: 18, fontFamily: "Semi", color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
