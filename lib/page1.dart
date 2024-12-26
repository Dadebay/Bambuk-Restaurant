import 'dart:convert';
import 'dart:io';

import 'package:bamboo/my_pages/arzan.dart';
import 'package:bamboo/my_pages/banner.dart';
import 'package:bamboo/my_pages/bash%20sahypa/search.dart';
import 'package:bamboo/my_pages/main_cat.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/user_reviews_page/review_card.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/widgets.dart';
import 'package:banner_image/banner_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  _Page1State createState() => _Page1State();
  final bool page = true;
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            _dialogBuilder(context);
          },
          icon: const Icon(Icons.language, color: AppColors.primary),
        ),
        title: logo(),
        actions: [
          IconButton(
              onPressed: () => UrlLauncher.launch("tel://+99363334994"),
              icon: const Icon(
                IconlyBold.call,
                color: AppColors.primary,
              ))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            searchWidget(context),
            const BannerScreen(),
            const MainCat(),
            (Constants.discount_products.isNotEmpty) ? MainVisibles(type: 0, items: Constants.discount_products) : Container(),
            (Constants.new_products.isNotEmpty) ? MainVisibles(type: 1, items: Constants.new_products) : Container(),
            const SizedBox(
              height: 30,
            ),
            const BannerScreen2(),
            reviewListDesign(prov),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Container searchWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Search()));
        },
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: AppColors.light_silver,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                IconlyLight.search,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                Constants.ru_search[Provider.of<Which_page>(context).dil],
                style: const TextStyle(color: AppColors.silver, fontFamily: 'Semi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewListDesign(Which_page prov) {
    print(prov.dil);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Text(
            Constants.review_user[prov.dil],
            style: const TextStyle(fontSize: 18, fontFamily: "Semi", color: Colors.black),
          ),
        ),
        FutureBuilder<List<ReviewModel>>(
            future: getReviews(),
            builder: (context, snapshot) {
              if (ConnectionState.waiting == snapshot.connectionState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return BannerImage(
                  aspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height) / 0.3,
                  itemLength: snapshot.data!.length,
                  selectedIndicatorColor: AppColors.appBar_back,
                  borderRadius: BorderRadius.circular(8),
                  autoPlay: true,
                  onTap: (int index) {},
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => ReviewCard(
                      image: snapshot.data![index].image!,
                      date: snapshot.data![index].date!,
                      title: prov.dil == 0
                          ? snapshot.data![index].titleRU!
                          : prov.dil == 2
                              ? snapshot.data![index].titleEN!
                              : snapshot.data![index].titleTM!,
                    ),
                  ),
                );
              }
              return const Center(child: Text('No data'));
            })
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontFamily: 'Semi', color: AppColors.primary, fontSize: 16),
                      ),
                      child: Text(
                        Constants.ru_selectLan[Provider.of<Which_page>(context).dil],
                        style: const TextStyle(fontFamily: 'Semi', color: AppColors.primary, fontSize: 16),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                          child: SvgPicture.asset(
                            'assets/images/language_selected.svg',
                            color: Provider.of<Which_page>(context).dil == 1 ? AppColors.primary : AppColors.silver,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'Türkmen dili',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Provider.of<Which_page>(context, listen: false).setTm();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                          child: SvgPicture.asset(
                            'assets/images/language_selected.svg',
                            color: Provider.of<Which_page>(context).dil == 0 ? AppColors.primary : AppColors.silver,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'Русский',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Provider.of<Which_page>(context, listen: false).setRu();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                          child: SvgPicture.asset(
                            'assets/images/language_selected.svg',
                            color: Provider.of<Which_page>(context).dil == 2 ? AppColors.primary : AppColors.silver,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'English',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Provider.of<Which_page>(context, listen: false).setEn();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<ReviewModel>> getReviews() async {
    final List<ReviewModel> categoryList = [];
    final response = await http.get(
      Uri.parse('https://bambukresto.com.tm:4443/api/v1/blogs'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body)['data'];
      for (final Map product in responseJson) {
        categoryList.add(ReviewModel.fromJson(product));
      }
      return categoryList;
    } else {
      return [];
    }
  }
}

class ReviewModel {
  final int? id;
  final String? titleTM;
  final String? titleRU;
  final String? titleEN;
  final String? image;
  final String? date;
  final int? viewed;
  ReviewModel({this.id, this.image, this.date, this.titleEN, this.titleRU, this.titleTM, this.viewed});

  factory ReviewModel.fromJson(Map<dynamic, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? 'Aman',
      date: json['date'] ?? 'Aman',
      viewed: json['viewed'] ?? 0,
      titleEN: json['title_en'] ?? 'Aman',
      titleRU: json['title_ru'] ?? 'Aman',
      titleTM: json['title_tm'] ?? 'Aman',
    );
  }
}
