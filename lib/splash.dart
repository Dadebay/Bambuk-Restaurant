import 'package:bamboo/DB/db.dart';
import 'package:bamboo/main.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:bamboo/values/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late var response3;
  bool connection = true;
  @override
  void initState() {
    super.initState();
    getTime();
  }

  final dio = Dio();
  Future get(String url) async {
    try {
      var repo = await dio.get('https://${Constants.api}$url');

      connection = true;
      return repo.data;
    } catch (e) {
      setState(() {
        connection = false;
      });
    }
  }

  Future getTime() async {
    final data = await DatabaseHelper.getUser();
    List<Map<String, dynamic>> myData = [];

    myData = data;

    if (myData.isNotEmpty) {
      Constants.phone = myData[0]['username'];
      Constants.token = myData[0]['token'];
      Constants.name = myData[0]['name'];
      Constants.name1 = myData[0]['name'];
      Constants.name2 = myData[0]['surname'];
      Constants.name = Constants.name1 + Constants.name2;

      Constants.email = myData[0]['email'];
      Provider.of<BottomProv>(context, listen: false).set_reg(true);
    }
    try {
      if (Constants.token != '') {
        Dio dio2 = Dio();
        dio2.options.headers["Authorization"] = "Bearer ${Constants.token}";
        var response = await dio2.get('https://${Constants.api}/api/v1/users/me/bonus');
        Constants.bonusMoney = response.data['amount'];
      }
    } catch (e) {}

    try {
      var repo = await get('/api/v1/locations');
      var mloc = repo['data'];
      Provider.of<Which_page>(context, listen: false).setDosMin(double.parse(mloc[0]['min_order_fee']));
      Provider.of<Which_page>(context, listen: false).setDosPrice(double.parse(mloc[0]['shipping_fee']));
    } catch (e) {}
    var repo = await get('/api/v1/categories');
    var mcat = repo['data'];
    for (int i = 0; i < mcat.length; i++) {
      Constants.category.add(categorys(
          id: mcat[i]['id'], name_tm: mcat[i]['name_tm'] ?? '', name_ru: mcat[i]['name_ru'] ?? '', name_en: mcat[i]['name_en'] ?? '', image: mcat[i]['image'], children: mcat[i]['children']));
    }
    try {
      var repo = await get('/api/v1/sliders');
      var mban = repo['data'];
      for (int i = 0; i < mban.length; i++) {
        Constants.banner.add(sliders(id: mban[i]['id'], image: mban[i]['image']['tm'], imageRu: mban[i]['image']['ru'], imageEn: mban[i]['image']['en']));
      }
    } catch (e) {}
    try {
      var repo = await get('/api/v1/comment-sliders');
      var mban = repo['data'];
      for (int i = 0; i < mban.length; i++) {
        Constants.commentBanner.add(
          CommentBanner(
            id: mban[i]['id'],
            nameTm: mban[i]['title']['tm'] ?? '',
            nameRu: mban[i]['title']['ru'] ?? '',
            contentTm: mban[i]['body']['tm'] ?? '',
            contentRu: mban[i]['body']['ru'] ?? '',
            imageTm: mban[i]['image']['tm'],
            imageRu: mban[i]['image']['ru'],
          ),
        );
      }
    } catch (e) {}
    try {
      var repo = await get('/api/v1/products/discounts');
      var mdis = repo['data'];
      for (int i = 0; i < mdis.length; i++) {
        Constants.discount_products.add(
          products(
              id: mdis[i]['id'],
              name_tm: mdis[i]['name_tm'] ?? '',
              name_ru: mdis[i]['name_ru'] ?? '',
              name_en: mdis[i]['name_en'] ?? '',
              description_tm: mdis[i]['descrioption_tm'] ?? "",
              description_ru: mdis[i]['descrioption_ru'] ?? "",
              description_en: mdis[i]['descrioption_en'] ?? "",
              image: mdis[i]['image'],
              price: double.parse(mdis[i]['price']),
              count: 0,
              rating: double.parse(mdis[i]['rating']),
              discount: mdis[i]['discount'],
              discount_price: (mdis[i]['discounted_price'] != null) ? double.parse(mdis[i]['discounted_price'].toString()) : 0.00,
              category: mdis[i]['category']['id'].toString(),
              values: mdis[i]['values']),
        );
      }
    } catch (e) {}
    try {
      var repo = await get('/api/v1/products/new');
      var mdis = repo['data'];
      for (int i = 0; i < mdis.length; i++) {
        Constants.new_products.add(
          products(
              id: mdis[i]['id'],
              name_tm: mdis[i]['name_tm'] ?? '',
              name_ru: mdis[i]['name_ru'] ?? '',
              name_en: mdis[i]['name_en'] ?? '',
              description_tm: mdis[i]['descrioption_tm'] ?? "",
              description_ru: mdis[i]['descrioption_ru'] ?? "",
              description_en: mdis[i]['descrioption_en'] ?? "",
              image: mdis[i]['image'],
              price: double.parse(mdis[i]['price']),
              count: 0,
              rating: double.parse(mdis[i]['rating']),
              discount: mdis[i]['discount'],
              discount_price: (mdis[i]['discounted_price'] != null) ? double.parse(mdis[i]['discounted_price'].toString()) : 0.00,
              category: mdis[i]['category']['id'].toString(),
              values: mdis[i]['values']),
        );
      }
    } catch (e) {}
    try {
      var repo = await get('/api/v1/brands/1/products');
      var mdis = repo['data'];
      for (int i = 0; i < mdis.length; i++) {
        Constants.hit_products.add(
          products(
              id: mdis[i]['id'],
              name_tm: mdis[i]['name_tm'] ?? '',
              name_ru: mdis[i]['name_ru'] ?? '',
              name_en: mdis[i]['name_en'] ?? '',
              description_tm: mdis[i]['descrioption_tm'] ?? "",
              description_ru: mdis[i]['descrioption_ru'] ?? "",
              description_en: mdis[i]['descrioption_en'] ?? "",
              image: mdis[i]['image'],
              price: double.parse(mdis[i]['price']),
              count: 0,
              rating: double.parse(mdis[i]['rating']),
              discount: mdis[i]['discount'],
              discount_price: (mdis[i]['discounted_price'] != null) ? double.parse(mdis[i]['discounted_price'].toString()) : 0.00,
              category: mdis[i]['category']['id'].toString(),
              values: mdis[i]['values']),
        );
      }
    } catch (e) {}
    final datum = await DatabaseHelper.getItems();
    List<Map<String, dynamic>> myDatum = [];
    myDatum = datum;
    for (int i = 0; i < myDatum.length; i++) {
      Provider.of<ProvItem>(context, listen: false).addSplash(
          myDatum[i]['productId'],
          myDatum[i]['name_tm'],
          myDatum[i]['name_ru'],
          myDatum[i]['name_en'],
          myDatum[i]['description_tm'],
          myDatum[i]['description_ru'],
          myDatum[i]['description_en'],
          myDatum[i]['image'],
          myDatum[i]['price'],
          myDatum[i]['count'],
          myDatum[i]['rating'],
          myDatum[i]['discount'],
          myDatum[i]['discount_price'],
          myDatum[i]['category'],
          myDatum[i]['values']);
    }
    try {
      final address = await DatabaseHelper.getAddress();
      List<Map<String, dynamic>> myaddress = [];
      myaddress = address;
      for (int i = 0; i < myaddress.length; i++) {
        // ignore: use_build_context_synchronously
        Provider.of<Favourite>(context, listen: false).addAddress(myaddress[i]['name'], myaddress[i]['address_txt']);
      }
    } catch (e) {}

    final fav = await DatabaseHelper.getFavor();
    List<Map<String, dynamic>> myFav = [];
    myFav = fav;
    for (int i = 0; i < myFav.length; i++) {
      Provider.of<Favourite>(context, listen: false).addSplash(
          myFav[i]['productId'],
          myFav[i]['name_tm'],
          myFav[i]['name_ru'],
          myFav[i]['name_en'],
          myFav[i]['description_tm'],
          myFav[i]['description_ru'],
          myFav[i]['description_en'],
          myFav[i]['image'],
          myFav[i]['price'],
          myFav[i]['count'],
          myFav[i]['rating'],
          myFav[i]['discount'],
          myFav[i]['discount_price'],
          myFav[i]['category'],
          myFav[i]['values']);
    }
    final diller = await DatabaseHelper.getDiller();
    List<Map<String, dynamic>> lan = diller;
    if (lan.isNotEmpty) {
      if (lan[0]['dil'] == 0) {
        Provider.of<Which_page>(context, listen: false).setRu();
      } else if (lan[0]['dil'] == 1)
        Provider.of<Which_page>(context, listen: false).setTm();
      else
        Provider.of<Which_page>(context, listen: false).setEn();
    } else {
      DatabaseHelper.createDill(1, 1);
    }

    Constants.dil = true;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logoImage,
              width: 170,
              height: 170,
            ),
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 50,
            ),
            const CircularProgressIndicator(
              strokeWidth: 4.0,
              color: AppColors.primary,
              semanticsLabel: 'Circular progress indicator',
            ),
          ],
        ),
      ),
    );
  }
}
