import 'package:bamboo/photo_view.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:bamboo/values/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class OptionsItem extends StatefulWidget {
  const OptionsItem({super.key, required this.image});
  final String image;
  @override
  _OptionsItemState createState() => _OptionsItemState();
}

class _OptionsItemState extends State<OptionsItem> {
  bool descrip = true;
  bool vis_size = true;
  bool vis_color = true;
  List<ColorPick> colors = [];
  List<String> sizes = [];
  String text_size = '';
  bool loading = true;
  List<products> product = [];

  Future getTime() async {
    product.add(products(
        id: Constants.op_id,
        name_tm: Constants.op_name_tm,
        name_ru: Constants.op_name_ru,
        name_en: Constants.op_name_en,
        description_tm: Constants.op_description_tm,
        description_ru: Constants.op_description_ru,
        description_en: Constants.op_description_en,
        image: Constants.op_image,
        price: Constants.op_price,
        count: Constants.op_count,
        rating: Constants.op_rating,
        discount: Constants.op_discount,
        discount_price: Constants.op_discount_price,
        category: Constants.op_category,
        values: Constants.op_values));
    loading = false;
    // var response3 = await http.get(Uri.https(Constants.api, '/api/v1/sets/${Constants.op_id}'));
    // print(Uri.https(Constants.api, '/api/v1/sets/${Constants.op_id}'));
    // log(response3.body);

    // var mitem = json.decode(utf8.decode(response3.bodyBytes))['data']['products'];

    // for (int i = 0; i < mitem.length; i++) {
    //   product.add(products(
    //       id: mitem[i]['id'],
    //       name_tm: mitem[i]['name_tm'] ?? '',
    //       name_ru: mitem[i]['name_ru'] ?? '',
    //       name_en: mitem[i]['name_en'] ?? '',
    //       description_tm: mitem[i]['description_tm'] ?? '',
    //       description_ru: mitem[i]['description_ru'] ?? '',
    //       description_en: mitem[i]['description_en'] ?? '',
    //       image: mitem[i]['image'],
    //       price: double.parse(mitem[i]['price']),
    //       count: 0,
    //       rating: double.parse(mitem[i]['rating']),
    //       discount: mitem[i]['discount'],
    //       discount_price: double.parse((mitem[i]['discounted_price'].toString() != null) ? mitem[i]['discounted_price'].toString() : "0.00"),
    //       category: mitem[i]['category']['id'].toString(),
    //       values: mitem[i]['values']));
    // }
    sizes = [];
    colors = [];

    try {
      for (int i = 0; i < Constants.op_values.length; i++) {
        if (Constants.op_values[i]['option']['is_color'] == "0") {
          colors.add(ColorPick(id: Constants.op_id, colors: Constants.op_values[i]['color']));
        }
      }
    } catch (e) {}

    try {
      for (int j = 0; j < product.length; j++) {
        for (int i = 0; i < product[j].values.length; i++) {
          if (product[j].values[i]['option']['is_color'] != "0") {
            colors.add(ColorPick(id: product[j].id, colors: product[j].values[i]['color']));
          }
        }
      }
    } catch (e) {}
    setState(() {});
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              // Get.back();
              Navigator.pop(context);
            },
            icon: const Icon(
              IconlyLight.arrow_left_circle,
              color: Colors.black,
            )),
        title: Text(
          Provider.of<Which_page>(context).dil == 1
              ? Constants.op_name_tm
              : Provider.of<Which_page>(context).dil == 0
                  ? Constants.op_name_ru
                  : Constants.op_name_en,
          style: const TextStyle(fontFamily: 'GilroyMedium'),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              imageview(
                image: widget.image,
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (prov.dil == 1)
                            ? Constants.op_name_tm
                            : prov.dil == 0
                                ? Constants.op_name_ru
                                : Constants.op_name_en,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 55,
                  margin: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 15),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(right: 10),
                        child: (Constants.op_discount != 0)
                            ? Row(
                                children: [
                                  Text(
                                    '${Constants.op_discount_price} TMT ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: 'Semi',
                                    ),
                                  ),
                                  Text(
                                    '${Constants.op_price} TMT ',
                                    style: const TextStyle(fontSize: 16, color: AppColors.light_black, fontFamily: 'Semi', decoration: TextDecoration.lineThrough),
                                  ),
                                ],
                              )
                            : Text(
                                '${Constants.op_price} TMT ',
                                style: const TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Semi'),
                              ),
                      ),
                    ],
                  )),
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 10, right: 15),
                height: 1,
                color: AppColors.silver,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    descrip = !descrip;
                  });
                },
                child: Container(
                  color: const Color.fromARGB(0, 255, 255, 255),
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Constants.ru_full_dep[prov.dil],
                        // ignore:
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontFamily: gilroyMedium,
                        ),
                      ),
                      (!descrip)
                          ? const Icon(
                              Icons.keyboard_arrow_right,
                            )
                          : const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: descrip,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: (prov.dil == 1)
                        ? Constants.op_description_tm
                        : prov.dil == 0
                            ? Constants.op_description_ru
                            : Constants.op_description_en,
                    style: {
                      "body": Style(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontFamily: 'Semi',
                        lineHeight: const LineHeight(1.5),
                        textAlign: TextAlign.justify,
                        fontSize: FontSize.xxLarge,
                      ),
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.only(left: 15, right: 15),
                color: AppColors.silver,
              ),
              const SizedBox(
                height: 10,
              ),
              (sizes.isNotEmpty)
                  ? ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              vis_size = !vis_size;
                            });
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  text_size,
                                  // ignore:
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: "Semi",
                                  ),
                                ),
                                (!vis_size)
                                    ? const Icon(
                                        Icons.keyboard_arrow_right,
                                      )
                                    : const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: vis_size,
                          child: const SizedBox(
                            height: 10,
                          ),
                        ),
                        Visibility(
                          visible: vis_size,
                          child: Container(
                            height: 55,
                            alignment: Alignment.center,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sizes.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.20),
                                        spreadRadius: 3,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: const EdgeInsets.all(10),
                                  child: Text(
                                    sizes[index],
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              (colors.isNotEmpty)
                  ? Container(
                      height: 1,
                      color: AppColors.silver,
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              (colors.isNotEmpty)
                  ? ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              vis_color = !vis_color;
                            });
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (prov.dil != 0) ? 'Reňkler' : 'Цвета',
                                  // ignore:
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: "Semi",
                                  ),
                                ),
                                (!vis_color)
                                    ? const Icon(
                                        Icons.keyboard_arrow_right,
                                      )
                                    : const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (vis_color)
                            ? Container(
                                height: 30,
                                alignment: Alignment.center,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: colors.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          Constants.op_id = product[index].id;
                                          Constants.op_name_tm = product[index].name_tm;
                                          Constants.op_name_ru = product[index].name_ru;
                                          Constants.op_description_tm = product[index].description_tm;
                                          Constants.op_description_ru = product[index].description_ru;
                                          Constants.op_image = product[index].image;
                                          Constants.op_price = product[index].price;
                                          Constants.op_count = product[index].count;
                                          Constants.op_rating = product[index].rating;
                                          Constants.op_discount = product[index].discount;
                                          Constants.op_discount_price = product[index].discount_price;
                                          Constants.op_category = product[index].category;
                                          Constants.op_values = product[index].values;
                                        });
                                      }),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Color(int.parse('0xff${colors[index].colors.replaceAll("#", "")}')),
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(),
                        Container(
                          height: 1,
                          color: AppColors.silver,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
          Positioned(bottom: 80, child: addCartButton(context)),
        ],
      ),
    );
  }

  Container addCartButton(BuildContext context) {
    return Container(
      width: Get.size.width - 20,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primary,
      ),
      child: (Provider.of<ProvItem>(context).items[Constants.op_id]?.count == null)
          ? GestureDetector(
              onTap: () {
                Provider.of<ProvItem>(context, listen: false).addItem(
                    Constants.op_id,
                    Constants.op_name_tm,
                    Constants.op_name_ru,
                    Constants.op_name_en,
                    Constants.op_description_tm,
                    Constants.op_description_ru,
                    Constants.op_description_en,
                    Constants.op_image,
                    Constants.op_price,
                    1,
                    Constants.op_rating,
                    Constants.op_discount,
                    Constants.op_discount_price,
                    Constants.op_category,
                    Constants.op_values);
              },
              child: Center(
                child: Text(
                  Constants.ru_AddCart[Provider.of<Which_page>(context).dil],
                  style: const TextStyle(color: Colors.white, fontFamily: 'Semi', fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Provider.of<ProvItem>(context, listen: false).removeItem(Constants.op_id, 5);
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Icon(CupertinoIcons.minus, color: Colors.black)),
                ),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    (Provider.of<ProvItem>(context).items[Constants.op_id]?.count == null) ? '0' : Provider.of<ProvItem>(context).items[Constants.op_id]!.count.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Semi'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<ProvItem>(context, listen: false).addItem(
                        Constants.op_id,
                        Constants.op_name_tm,
                        Constants.op_name_ru,
                        Constants.op_name_en,
                        Constants.op_description_tm,
                        Constants.op_description_ru,
                        Constants.op_description_en,
                        Constants.op_image,
                        Constants.op_price,
                        1,
                        Constants.op_rating,
                        Constants.op_discount,
                        Constants.op_discount_price,
                        Constants.op_category,
                        Constants.op_values);
                  },
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Icon(Icons.add, color: Colors.black)),
                ),
              ],
            ),
    );
  }
}

class imageview extends StatelessWidget {
  const imageview({
    super.key,
    required this.image,
  });
  final String image;
  GestureDetector favButton(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        if (Provider.of<Favourite>(context, listen: false).items[Constants.op_id]?.count == null) {
          Provider.of<Favourite>(context, listen: false).addItem(
              Constants.op_id,
              Constants.op_name_tm,
              Constants.op_name_ru,
              Constants.op_name_en,
              Constants.op_description_tm,
              Constants.op_description_ru,
              Constants.op_description_en,
              Constants.op_image,
              Constants.op_price,
              Constants.op_count,
              Constants.op_rating,
              Constants.op_discount,
              Constants.op_discount_price,
              Constants.op_category,
              Constants.op_values);
        } else {
          Provider.of<Favourite>(context, listen: false).removeItem(Constants.op_id);
        }
      }),
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: (Provider.of<Favourite>(context).items[Constants.op_id]?.count == null)
            ? const Icon(
                Icons.favorite_border,
                color: Colors.black,
              )
            : const Icon(
                Icons.favorite,
                color: Color.fromARGB(255, 218, 44, 32),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.size.width,
      height: Get.size.height / 2.5,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PhotView()));
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: Get.size.width,
              ),
            ),
          ),
          Positioned(right: 10, top: 10, child: favButton(context)),
          Positioned(
              right: 10,
              bottom: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PhotView()));
                },
                child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(
                      IconlyLight.search,
                      color: Colors.black,
                    )),
              )),
        ],
      ),
    );
  }
}
