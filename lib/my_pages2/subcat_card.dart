import 'package:flutter/material.dart';
import 'package:bamboo/my_pages2/sub_cat.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

class SubcatCard extends StatefulWidget {
  int id;
  String name_tm;
  String name_ru;
  String image;
  var children;
  SubcatCard(this.id, this.name_tm, this.name_ru, this.image, this.children, {super.key});

  @override
  _SubcatCardState createState() => _SubcatCardState();
}

class _SubcatCardState extends State<SubcatCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Constants.myCatID = widget.id;
        Constants.myCatName = (Provider.of<Which_page>(context, listen: false).dil != 0) ? widget.name_tm : widget.name_ru;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubCat()));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: AppColors.light_silver,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 275),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                (Provider.of<Which_page>(context).dil != 0) ? widget.name_tm : widget.name_ru,
                maxLines: 2,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
            )
          ],
        ),
      ),
    );
  }
}
