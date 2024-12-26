import 'package:bamboo/my_pages/cart_items.dart';
import 'package:bamboo/my_pages2/cart_item_linear.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../my_pages/bash sahypa/search.dart';
import '../providers/page1provider.dart';
import '../values/models.dart';

class SubCat extends StatefulWidget {
  const SubCat({super.key});

  @override
  _SubCatState createState() => _SubCatState();
}

class _SubCatState extends State<SubCat> {
  List<products> product = [];
  bool _list = false;
  int _selected = 0;
  List<category_home2> children = [];
  bool loading = true;
  int pindex = -2;
  int page = 0;
  String sort_by = 'cheap';
  bool canGet = true;
  final dio = Dio();
  Future get() async {
    try {
      var repo = await dio.get('https://${Constants.api}/api/v1/products/', queryParameters: {'category': '${Constants.myCatID}', 'page': '$page', 'limit': '20'});
      return repo.data;
    } catch (e) {}
  }

  Future getTime() async {
    page++;
    var response3 = await get();
    var mitem = response3['data'];
    if (mitem.length == 0) {
      setState(() {
        canGet = false;
      });
    }
    for (int i = 0; i < mitem.length; i++) {
      product.add(products(
          id: mitem[i]['id'],
          name_tm: mitem[i]['name_tm'] ?? ' ',
          name_ru: mitem[i]['name_ru'] ?? ' ',
          name_en: mitem[i]['name_en'] ?? ' ',
          description_tm: mitem[i]['descrioption_tm'] ?? ' ',
          description_ru: mitem[i]['descrioption_ru'] ?? ' ',
          description_en: mitem[i]['descrioption_en'] ?? ' ',
          image: mitem[i]['image'],
          price: double.parse(mitem[i]['price']),
          count: mitem[i]['count'],
          rating: double.parse(mitem[i]['rating']),
          discount: mitem[i]['discount'],
          discount_price: double.parse(mitem[i]['discounted_price'] == null ? "0.00" : mitem[i]['discounted_price'].toString()),
          category: mitem[i]['category']['id'].toString(),
          values: mitem[i]['values']));
    }
    print('object1');
    try {
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        canGet = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      children.add(category_home2(id: Constants.myCatID, name_tm: 'Ählisi', name_ru: 'Все', name_en: 'All'));
      for (int j = 0; j < Constants.children.length; j++) {
        try {
          children.add(category_home2(
              id: Constants.children[j]['id'], name_tm: Constants.children[j]['name_tm'] ?? '', name_ru: Constants.children[j]['name_ru'] ?? '', name_en: Constants.children[j]['name_en'] ?? ''));
        } catch (e) {}
      }
    } catch (e) {}
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    var provDil = Provider.of<Which_page>(context).dil;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(left: 5, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.light_silver,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/back.svg',
                      color: Colors.black,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                ),
                Expanded(
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
                          const SizedBox(
                            width: 10,
                          ),
                          SvgPicture.asset(
                            'assets/images/search.svg',
                            color: AppColors.silver,
                            allowDrawingOutsideViewBox: true,
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
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Text(
                    Constants.myCatName,
                    style: const TextStyle(fontFamily: 'Semi', fontSize: 16, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _list = false;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/images/man2.svg',
                    color: !_list ? AppColors.primary : Colors.black,
                    fit: BoxFit.none,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _list = true;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/images/listview.svg',
                    color: _list ? AppColors.primary : Colors.black,
                    fit: BoxFit.none,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
              ],
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: children.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selected = index;
                          loading == true;
                          product = [];
                          canGet = true;
                          page = 0;
                        });
                        Constants.myCatID = children[index].id;
                        getTime();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: (index == _selected) ? AppColors.primary.withOpacity(0.4) : AppColors.light_silver),
                        child: Text(
                          Provider.of<Which_page>(context).dil == 0
                              ? children[index].name_ru
                              : Provider.of<Which_page>(context).dil == 1
                                  ? children[index].name_tm
                                  : children[index].name_en,
                          style: TextStyle(fontSize: 15, fontFamily: gilroyMedium, color: (index == _selected) ? Colors.black : Colors.black),
                        ),
                      ),
                    );
                  }),
            ),
            (loading == false)
                ? Expanded(
                    child: _list
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: product.length,
                            itemBuilder: (context, index) {
                              if (index == product.length - 1 && canGet) {
                                getTime();
                              }
                              return CartItemsLinear(
                                  product[index].id,
                                  product[index].name_tm,
                                  product[index].name_ru,
                                  product[index].name_en,
                                  product[index].description_tm,
                                  product[index].description_ru,
                                  product[index].description_en,
                                  product[index].image,
                                  product[index].price,
                                  product[index].count,
                                  product[index].rating,
                                  product[index].discount,
                                  product[index].discount_price,
                                  product[index].category,
                                  product[index].values);
                            },
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 315,
                            ),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            primary: false,
                            itemCount: product.length,
                            itemBuilder: (context, index) {
                              if (index == product.length - 1 && canGet) {
                                getTime();
                              }
                              return CartItems(
                                  product[index].id,
                                  product[index].name_tm,
                                  product[index].name_ru,
                                  product[index].name_en,
                                  product[index].description_tm,
                                  product[index].description_ru,
                                  product[index].description_en,
                                  product[index].image,
                                  product[index].price,
                                  product[index].count,
                                  product[index].rating,
                                  product[index].discount,
                                  product[index].discount_price,
                                  product[index].category,
                                  product[index].values);
                            },
                          ),
                  )
                : Expanded(
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          strokeWidth: 4.0,
                          semanticsLabel: 'Circular progress indicator',
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
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
                        (Provider.of<Which_page>(context).dil != 0) ? 'FILTER' : 'ФИЛЬТР',
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                        ),
                        TextButton(
                          child: Text(
                            (Provider.of<Which_page>(context).dil != 0) ? 'ARZANDAN GYMMADA' : 'СНАЧАЛА ДЕШЕВЫЕ',
                            style: const TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              loading = true;
                              sort_by = 'cheap';
                            });
                            getTime();
                            Navigator.pop(context);
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                        ),
                        TextButton(
                          child: Text(
                            (Provider.of<Which_page>(context).dil != 0) ? 'GYMMATDAN ARZANA' : 'СНАЧАЛА ДОРОГИЕ',
                            style: const TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              sort_by = 'expensive';
                              loading = true;
                            });
                            getTime();
                            Navigator.pop(context);
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                        ),
                        TextButton(
                          child: Text(
                            (Provider.of<Which_page>(context).dil != 0) ? 'KÖNEDEN TÄZE' : 'СНАЧАЛА СТАРЫЕ',
                            style: const TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              sort_by = 'oldest';
                              loading = true;
                            });
                            getTime();
                            Navigator.pop(context);
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
                        ),
                        TextButton(
                          child: Text(
                            (Provider.of<Which_page>(context).dil != 0) ? 'TÄZEDEN KÖNÄ' : 'СНАЧАЛА НОВИНКИ',
                            style: const TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              sort_by = 'latest';
                              loading = true;
                            });
                            getTime();
                            Navigator.pop(context);
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
}
