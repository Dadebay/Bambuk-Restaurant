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
  bool _connection = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserData();
    await _fetchDeliverySettings();
    await _fetchCategories();
    await _fetchBanners();
    await _fetchCommentBanners();
    await _fetchDiscountProducts();
    await _fetchNewProducts();
    await _fetchHitProducts();
    await _loadCartItems();
    await _loadAddresses();
    await _loadFavoriteItems();
    await _loadLanguageSettings();

    // Tüm işlemler bittikten sonra ana sayfaya geç
    if (mounted) {
      // Sayfa hala aktif mi kontrolü
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    }
  }

  Future<void> _loadUserData() async {
    final userData = await DatabaseHelper.getUser();

    if (userData.isNotEmpty) {
      Constants.phone = userData[0]['username'];
      Constants.token = userData[0]['token'];
      Constants.name = userData[0]['name'];
      Constants.name1 = userData[0]['name'];
      Constants.name2 = userData[0]['surname'];
      Constants.name = Constants.name1 + Constants.name2;
      Constants.email = userData[0]['email'];
      Provider.of<BottomProv>(context, listen: false).set_reg(true);
    }

    try {
      if (Constants.token.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer ${Constants.token}";
        final response = await _dio.get('https://${Constants.api}/api/v1/users/me/bonus');
        Constants.bonusMoney = response.data['amount'].toString();
      }
    } catch (e) {
      print('Error fetching bonus data: $e');
    }
  }

  Future<void> _fetchDeliverySettings() async {
    try {
      final response = await _get('/api/v1/locations');
      if (response != null && response['data'] != null && response['data'].isNotEmpty) {
        final location = response['data'][0];
        Provider.of<Which_page>(context, listen: false).setDosMin(double.parse(location['min_order_fee']));
        Provider.of<Which_page>(context, listen: false).setDosPrice(double.parse(location['shipping_fee']));
      }
    } catch (e) {
      print('Error fetching delivery settings: $e');
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await _get('/api/v1/categories');
      if (response != null && response['data'] != null) {
        final categoriesData = response['data'] as List<dynamic>;
        if (categoriesData.isNotEmpty) {
          Constants.category.clear(); // listeyi temizle
          for (var category in categoriesData) {
            Constants.category.add(
              categorys(
                id: category['id'],
                name_tm: category['name_tm'] ?? '',
                name_ru: category['name_ru'] ?? '',
                name_en: category['name_en'] ?? '',
                image: category['image'],
                children: category['children'],
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final response = await _get('/api/v1/sliders');
      if (response != null && response['data'] != null) {
        final bannersData = response['data'] as List<dynamic>;
        if (bannersData.isNotEmpty) {
          Constants.banner.clear(); // listeyi temizle
          for (var banner in bannersData) {
            Constants.banner.add(
              sliders(
                id: banner['id'],
                image: banner['image']['tm'],
                imageRu: banner['image']['ru'],
                imageEn: banner['image']['en'],
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching banners: $e');
    }
  }

  Future<void> _fetchCommentBanners() async {
    try {
      final response = await _get('/api/v1/comment-sliders');
      if (response != null && response['data'] != null) {
        final commentBannersData = response['data'] as List<dynamic>;
        if (commentBannersData.isNotEmpty) {
          Constants.commentBanner.clear(); // listeyi temizle
          for (var banner in commentBannersData) {
            Constants.commentBanner.add(
              CommentBanner(
                id: banner['id'],
                nameTm: banner['title']['tm'] ?? '',
                nameRu: banner['title']['ru'] ?? '',
                contentTm: banner['body']['tm'] ?? '',
                contentRu: banner['body']['ru'] ?? '',
                imageTm: banner['image']['tm'],
                imageRu: banner['image']['ru'],
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching comment banners: $e');
    }
  }

  Future<void> _fetchDiscountProducts() async {
    await _fetchProducts('/api/v1/products/discounts', Constants.discount_products);
  }

  Future<void> _fetchNewProducts() async {
    await _fetchProducts('/api/v1/products/new', Constants.new_products);
  }

  Future<void> _fetchHitProducts() async {
    await _fetchProducts('/api/v1/brands/1/products', Constants.hit_products);
  }

  Future<void> _fetchProducts(String endpoint, List<products> targetList) async {
    try {
      final response = await _get(endpoint);
      if (response != null && response['data'] != null) {
        final productsData = response['data'] as List<dynamic>;
        if (productsData.isNotEmpty) {
          targetList.clear();
          for (var product in productsData) {
            targetList.add(
              products(
                id: product['id'],
                name_tm: product['name_tm'] ?? '',
                name_ru: product['name_ru'] ?? '',
                name_en: product['name_en'] ?? '',
                description_tm: product['descrioption_tm'] ?? "",
                description_ru: product['descrioption_ru'] ?? "",
                description_en: product['descrioption_en'] ?? "",
                image: product['image'],
                price: double.parse(product['price'].toString()),
                count: 0,
                rating: double.parse(product['rating'].toString()),
                discount: product['discount'],
                discount_price: (product['discounted_price'] != null) ? double.parse(product['discounted_price'].toString()) : 0.00,
                category: product['category']['id'].toString(),
                values: product['values'],
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching products from $endpoint: $e');
    }
  }

  Future<void> _loadCartItems() async {
    final cartItems = await DatabaseHelper.getItems();
    Provider.of<ProvItem>(context, listen: false).clearItem();
    for (var item in cartItems) {
      Provider.of<ProvItem>(context, listen: false).addSplash(item['productId'], item['name_tm'], item['name_ru'], item['name_en'], item['description_tm'], item['description_ru'],
          item['description_en'], item['image'], item['price'], item['count'], item['rating'], item['discount'], item['discount_price'], item['category'], item['values']);
    }
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await DatabaseHelper.getAddress();
      Provider.of<Favourite>(context, listen: false).clearAddress();
      for (var address in addresses) {
        Provider.of<Favourite>(context, listen: false).addAddress(address['name'], address['address_txt']);
      }
    } catch (e) {
      print('Error fetching addresses from database: $e');
    }
  }

  Future<void> _loadFavoriteItems() async {
    final favoriteItems = await DatabaseHelper.getFavor();
    Provider.of<Favourite>(context, listen: false);
    for (var item in favoriteItems) {
      Provider.of<Favourite>(context, listen: false).addSplash(item['productId'], item['name_tm'], item['name_ru'], item['name_en'], item['description_tm'], item['description_ru'],
          item['description_en'], item['image'], item['price'], item['count'], item['rating'], item['discount'], item['discount_price'], item['category'], item['values']);
    }
  }

  Future<void> _loadLanguageSettings() async {
    final languageData = await DatabaseHelper.getDiller();
    if (languageData.isNotEmpty) {
      final language = languageData[0]['dil'];
      if (language == 0) {
        Provider.of<Which_page>(context, listen: false).setRu();
      } else if (language == 1) {
        Provider.of<Which_page>(context, listen: false).setTm();
      } else {
        Provider.of<Which_page>(context, listen: false).setEn();
      }
    } else {
      DatabaseHelper.createDill(1, 1);
    }
    Constants.dil = true;
  }

  Future<dynamic> _get(String url) async {
    try {
      final response = await _dio.get('https://${Constants.api}$url');
      setState(() {
        _connection = true;
      });
      return response.data;
    } catch (e) {
      setState(() {
        _connection = false;
      });
      print('Error fetching data from $url: $e');
      return null;
    }
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
            const SizedBox(height: 50),
            if (_connection)
              const CircularProgressIndicator(
                strokeWidth: 4.0,
                color: AppColors.primary,
                semanticsLabel: 'Circular progress indicator',
              )
            else
              const Text("No connection"),
          ],
        ),
      ),
    );
  }
}
