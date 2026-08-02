import 'package:bamboo/my_pages/category_cart.dart';
import 'package:bamboo/providers/page1provider.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
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
  bool _isGrid = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _isGrid = !_isGrid),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  _isGrid ? Icons.view_agenda_rounded : Icons.grid_view_rounded,
                  key: ValueKey(_isGrid),
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
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
              child: Icon(IconlyBold.call, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: _isGrid
          ? GridView.builder(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80, top: 15),
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: 190,
              ),
              itemCount: Constants.category.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryCart(
                  Constants.category[index].id,
                  Constants.category[index].name_tm,
                  Constants.category[index].name_ru,
                  Constants.category[index].name_en,
                  Constants.category[index].image,
                  Constants.category[index].children,
                  isGrid: true,
                  scrollController: _scrollController,
                );
              })
          : ListView.builder(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80, top: 15),
              controller: _scrollController,
              itemCount: Constants.category.length,
              itemBuilder: (BuildContext context, int index) {
                return CategoryCart(
                  Constants.category[index].id,
                  Constants.category[index].name_tm,
                  Constants.category[index].name_ru,
                  Constants.category[index].name_en,
                  Constants.category[index].image,
                  Constants.category[index].children,
                  isGrid: false,
                  scrollController: _scrollController,
                );
              }),
    );
  }
}
