import 'package:bamboo/values/call_helper.dart';
import 'dart:convert';
import 'dart:io';

import 'package:bamboo/my_pages/restaurant_map_widget.dart';
import 'package:bamboo/my_pages/arzan.dart';
import 'package:bamboo/my_pages/banner.dart';
import 'package:bamboo/my_pages/bash%20sahypa/search.dart';
import 'package:bamboo/my_pages/main_cat.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/user_reviews_page/review_card.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Colors.transparent,
      appBar: const PreferredSize(preferredSize: Size.fromHeight(0), child: SizedBox.shrink()),
      body: ListView(
        children: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _dialogBuilder(context);
                },
                icon: const Icon(Icons.language, color: AppColors.primary),
              ),
              Expanded(
                  child: Center(
                child: Image.asset(
                  Constants.logoImage,
                  fit: BoxFit.contain,
                  width: 70,
                  alignment: Alignment.center,
                  height: 60,
                ),
              )),
              IconButton(
                  onPressed: () => callRestaurant(context),
                  icon: const Icon(
                    IconlyBold.call,
                    color: AppColors.primary,
                  ))
            ],
          ),
          searchWidget(context),
          const BannerScreen(),
          const MainCat(),
          (Constants.discount_products.isNotEmpty) ? MainVisibles(type: 0, items: Constants.discount_products) : Container(),
          (Constants.new_products.isNotEmpty) ? MainVisibles(type: 1, items: Constants.new_products) : Container(),
          const BannerScreen2(),
          const RestaurantMapWidget(),
          reviewListDesign(prov),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  Widget searchWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Search()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
        decoration: BoxDecoration(
          color: AppColors.light_silver,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              IconlyLight.search,
              color: Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(
              Constants.ru_search[Provider.of<Which_page>(context).dil],
              style: const TextStyle(color: AppColors.silver, fontFamily: 'Semi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget reviewListDesign(Which_page prov) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.rate_review_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.review_user[prov.dil],
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "GilroyBold",
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Constants.customer_reviews_title[prov.dil],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Monto",
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Reviews List
          FutureBuilder<List<ReviewModel>>(
            future: getReviews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return SizedBox(
                  height: 320,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final review = snapshot.data![index];
                      return SizedBox(
                        // Planşetde kart aşa giň bolmaz ýaly çäk.
                        width: MediaQuery.of(context).size.shortestSide >= 600 ? 360 : MediaQuery.of(context).size.width * 0.75,
                        child: ReviewCard(
                          image: review.image!,
                          date: review.date!,
                          title: prov.dil == 0
                              ? review.titleRU!
                              : prov.dil == 2
                                  ? review.titleEN!
                                  : review.titleTM!,
                        ),
                      );
                    },
                  ),
                );
              }
              return Container(
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      Constants.no_reviews_yet[prov.dil],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Semi',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final currentDil = Provider.of<Which_page>(context).dil;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Title row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.translate_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    Constants.ru_selectLan[currentDil],
                    style: const TextStyle(
                      fontFamily: 'GilroyBold',
                      fontSize: 20,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Language options
              _buildLanguageOption(
                context: context,
                flag: '🇹🇲',
                label: 'Türkmen dili',
                isSelected: currentDil == 1,
                onTap: () {
                  Provider.of<Which_page>(context, listen: false).setTm();
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 10),
              _buildLanguageOption(
                context: context,
                flag: '🇷🇺',
                label: 'Русский',
                isSelected: currentDil == 0,
                onTap: () {
                  Provider.of<Which_page>(context, listen: false).setRu();
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 10),
              _buildLanguageOption(
                context: context,
                flag: '🇬🇧',
                label: 'English',
                isSelected: currentDil == 2,
                onTap: () {
                  Provider.of<Which_page>(context, listen: false).setEn();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String flag,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.08) : const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFEEEEEE),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Flag emoji
              Text(
                flag,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 14),
              // Language name
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: isSelected ? 'GilroyBold' : 'GilroyMedium',
                    fontSize: 16,
                    color: isSelected ? AppColors.primary : const Color(0xFF2D2D2D),
                  ),
                ),
              ),
              // Selection indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : const Color(0xFFCCCCCC),
                    width: 2,
                  ),
                ),
                child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
              ),
            ],
          ),
        ),
      ),
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
