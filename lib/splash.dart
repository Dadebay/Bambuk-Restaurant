import 'dart:developer';

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

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool _connection = true;
  final Dio _dio = Dio();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade animasyonu
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Scale animasyonu
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
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
      if (!mounted) return;
      Provider.of<BottomProv>(context, listen: false).set_reg(true);
    }

    try {
      if (Constants.token.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer ${Constants.token}";
        final response =
            await _dio.get('https://${Constants.api}/api/v1/users/me/bonus');
        Constants.bonusMoney = response.data['amount'].toString();
      }
    } catch (e) {}
  }

  Future<void> _fetchDeliverySettings() async {
    try {
      final response = await _get('/api/v1/locations');
      if (!mounted) return;
      if (response != null &&
          response['data'] != null &&
          response['data'].isNotEmpty) {
        final location = response['data'][0];
        Provider.of<Which_page>(context, listen: false)
            .setDosMin(double.parse(location['min_order_fee']));
        Provider.of<Which_page>(context, listen: false)
            .setDosPrice(double.parse(location['shipping_fee']));
      }
    } catch (e) {}
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
    } catch (e) {}
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
    } catch (e) {}
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
    } catch (e) {}
  }

  Future<void> _fetchDiscountProducts() async {
    await _fetchProducts(
        '/api/v1/products/discounts', Constants.discount_products);
  }

  Future<void> _fetchNewProducts() async {
    await _fetchProducts('/api/v1/products/new', Constants.new_products);
  }

  Future<void> _fetchHitProducts() async {
    await _fetchProducts('/api/v1/brands/1/products', Constants.hit_products);
  }

  Future<void> _fetchProducts(
      String endpoint, List<products> targetList) async {
    try {
      final response = await _get(endpoint);
      if (response != null && response['data'] != null) {
        final productsData = response['data'] as List<dynamic>;
        log(productsData.toString());
        if (productsData.isNotEmpty) {
          targetList.clear();
          for (var product in productsData) {
            targetList.add(
              products(
                id: product['id'],
                name_tm: product['name_tm'] ?? '',
                name_ru: product['name_ru'] ?? '',
                name_en: product['name_en'] ?? '',
                description_tm: product['description_tm'] ?? "",
                description_ru: product['description_ru'] ?? "",
                description_en: product['description_en'] ?? "",
                image: product['image'],
                price: double.parse(product['price'].toString()),
                count: 0,
                quantity_step:
                    stepOf(toDouble(product['quantity_step'], fallback: 1.0)),
                rating: double.parse(product['rating'].toString()),
                discount: product['discount'],
                discount_price: (product['discounted_price'] != null)
                    ? double.parse(product['discounted_price'].toString())
                    : 0.00,
                category: product['category']['id'].toString(),
                values: product['values'],
              ),
            );
          }
        }
      }
    } catch (e) {}
  }

  Future<void> _loadCartItems() async {
    final cartItems = await DatabaseHelper.getItems();
    if (!mounted) return;
    Provider.of<ProvItem>(context, listen: false).clearItem();
    for (var item in cartItems) {
      Provider.of<ProvItem>(context, listen: false).addSplash(
          item['productId'],
          item['name_tm'],
          item['name_ru'],
          item['name_en'],
          item['description_tm'],
          item['description_ru'],
          item['description_en'],
          item['image'],
          toDouble(item['price']),
          toDouble(item['count']),
          toDouble(item['rating']),
          item['discount'],
          toDouble(item['discount_price']),
          item['category'],
          item['values'],
          stepOf(toDouble(item['quantity_step'], fallback: 1.0)));
    }
  }

  Future<void> _loadAddresses() async {
    try {
      final addresses = await DatabaseHelper.getAddress();
      if (!mounted) return;
      Provider.of<Favourite>(context, listen: false).clearAddress();
      for (var address in addresses) {
        Provider.of<Favourite>(context, listen: false)
            .addAddress(address['name'], address['address_txt']);
      }
    } catch (e) {}
  }

  Future<void> _loadFavoriteItems() async {
    final favoriteItems = await DatabaseHelper.getFavor();
    if (!mounted) return;
    Provider.of<Favourite>(context, listen: false);
    for (var item in favoriteItems) {
      Provider.of<Favourite>(context, listen: false).addSplash(
          item['productId'],
          item['name_tm'],
          item['name_ru'],
          item['name_en'],
          item['description_tm'],
          item['description_ru'],
          item['description_en'],
          item['image'],
          toDouble(item['price']),
          toDouble(item['count']),
          toDouble(item['rating']),
          item['discount'],
          toDouble(item['discount_price']),
          item['category'],
          item['values'],
          stepOf(toDouble(item['quantity_step'], fallback: 1.0)));
    }
  }

  Future<void> _loadLanguageSettings() async {
    final languageData = await DatabaseHelper.getDiller();
    if (!mounted) return;
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
      if (mounted) {
        setState(() {
          _connection = true;
        });
      }
      return response.data;
    } catch (e) {
      if (mounted) {
        setState(() {
          _connection = false;
        });
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.1),
              Colors.white,
              AppColors.primary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Dekoratif pattern circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Ana içerik
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo container
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              logoImage,
                              width: 140,
                              height: 140,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Restaurant name
                          const Text(
                            'BAMBOO RESTAURANT',
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'GilroyBold',
                              color: Colors.black87,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Slogan
                          const Text(
                            'AJAÝYP AZIÝA TAGAMLARY',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Gilroy',
                              color: Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Loading indicator veya connection mesajı
                          Consumer<Which_page>(
                            builder: (context, pageProvider, _) {
                              if (_connection) {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.primary),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      splash_loading[pageProvider.dil],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Semi',
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.red.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.wifi_off_rounded,
                                        color: Colors.red.shade400,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        splash_no_internet[pageProvider.dil],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Semi',
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        splash_check_internet[pageProvider.dil],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Monto',
                                          color: Colors.red.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Version text (alt kısımda)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: Consumer<Which_page>(
                    builder: (context, pageProvider, _) => Text(
                      ru_version[pageProvider.dil],
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'Monto',
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
