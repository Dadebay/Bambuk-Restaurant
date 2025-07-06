import 'package:bamboo/my_pages2/sub_cat.dart';
import 'package:bamboo/providers/page1provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryCart extends StatefulWidget {
  int id;
  String name_tm;
  String name_ru;
  String name_en;
  String image;
  var children;
  CategoryCart(this.id, this.name_tm, this.name_ru, this.name_en, this.image, this.children, {super.key});

  @override
  _CategoryCartState createState() => _CategoryCartState();
}

class _CategoryCartState extends State<CategoryCart> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Constants.children = widget.children;
        Constants.myCatID = widget.id;
        Constants.myCatName = (Provider.of<Which_page>(context, listen: false).dil == 1)
            ? widget.name_tm
            : Provider.of<Which_page>(context, listen: false).dil == 0
                ? widget.name_ru
                : widget.name_en;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubCat()));
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 3, blurRadius: 3)], borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  imageUrl: widget.image,
                  errorWidget: (context, url, error) => Image.asset(logoImage),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text(
                  (Provider.of<Which_page>(context).dil == 1)
                      ? widget.name_tm
                      : Provider.of<Which_page>(context).dil == 0
                          ? widget.name_ru
                          : widget.name_en,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, height: 1.0, fontSize: 18, fontFamily: 'Semi'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
