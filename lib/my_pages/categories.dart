import 'package:bamboo/my_pages/category_cart.dart';
import 'package:bamboo/providers/page1provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../values/colors.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool stat = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Navigator.canPop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            Constants.ru_category[Provider.of<Which_page>(context).dil],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Semi',
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => UrlLauncher.launch("tel://+99363334994"),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset(
                  'assets/images/call.svg',
                  color: AppColors.primary,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ),
          ],
        ),
        body: GridView.builder(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80, top: 15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 185, // here set custom Height You Want
            ),
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            primary: false,
            itemCount: Constants.category.length,
            itemBuilder: (BuildContext context, int index) {
              return CategoryCart(
                Constants.category[index].id,
                Constants.category[index].name_tm,
                Constants.category[index].name_ru,
                Constants.category[index].name_en,
                Constants.category[index].image,
                Constants.category[index].children,
              );
            }),
      ),
    );
  }
}
