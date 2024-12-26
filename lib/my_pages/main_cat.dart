import 'package:bamboo/values/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bamboo/values/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/constants.dart' as Constants;

import '../my_pages2/sub_cat.dart';
import '../values/models.dart';

class MainCat extends StatefulWidget {
  const MainCat({super.key});

  @override
  _MainCatState createState() => _MainCatState();
}

class _MainCatState extends State<MainCat> {
  List<categorys> child = [];
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    return Column(
      children: [
        topPartName(prov, context),
        SizedBox(
          height: 170,
          child: ListView.builder(
              itemCount: Constants.category.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    Constants.children = Constants.category[index].children;
                    Constants.myCatID = Constants.category[index].id;
                    Constants.myCatName = (Provider.of<Which_page>(context, listen: false).dil != 0) ? Constants.category[index].name_tm : Constants.category[index].name_ru;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SubCat()));
                  },
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 3, blurRadius: 3)],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: Constants.category[index].image,
                            placeholder: (context, url) => Image.asset(logoImage),
                            errorWidget: (context, url, error) => Image.asset(logoImage),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Text(
                            prov.dil == 1
                                ? Constants.category[index].name_tm
                                : prov.dil == 0
                                    ? Constants.category[index].name_ru
                                    : Constants.category[index].name_en,
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Semi'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget topPartName(Which_page prov, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<BottomProv>(context, listen: false).setPage1();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Constants.ru_category[prov.dil],
              style: const TextStyle(fontSize: 18, fontFamily: "Semi", color: Colors.black),
            ),
            const Icon(
              IconlyLight.arrow_right_circle,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
