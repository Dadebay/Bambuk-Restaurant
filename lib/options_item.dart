import 'package:bamboo/photo_view.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart';
import 'package:bamboo/values/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
        quantity_step: Constants.op_quantity_step,
        rating: Constants.op_rating,
        discount: Constants.op_discount,
        discount_price: Constants.op_discount_price,
        category: Constants.op_category,
        values: Constants.op_values));
    loading = false;

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
    final prov = Provider.of<Which_page>(context);
    final size = MediaQuery.of(context).size;
    final String name = prov.dil == 1
        ? Constants.op_name_tm
        : prov.dil == 0
            ? Constants.op_name_ru
            : Constants.op_name_en;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
              ),
              child: const Icon(IconlyLight.arrow_left_circle, color: Colors.black, size: 22),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
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
                    Constants.op_values,
                  );
                } else {
                  Provider.of<Favourite>(context, listen: false).removeItem(Constants.op_id);
                }
                setState(() {});
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
                ),
                child: Center(
                  child: (Provider.of<Favourite>(context).items[Constants.op_id]?.count == null)
                      ? const Icon(IconlyLight.heart, color: AppColors.primary, size: 20)
                      : const Icon(IconlyBold.heart, color: Color.fromARGB(255, 218, 44, 32), size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              // ── Hero image ──────────────────────────────────────────────
              SizedBox(
                height: size.height * 0.48,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.image,
                      placeholder: (_, __) => Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) => Image.asset(logoImage, fit: BoxFit.cover),
                    ),
                    // bottom fade so content card blends into image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 80,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.white, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                    // zoom button
                    Positioned(
                      bottom: 40,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotView())),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)],
                          ),
                          child: const Icon(IconlyLight.search, color: Colors.black, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content card (overlaps image via Transform) ────────────
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // drag handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 6),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // ── Product name ───────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                        child: Text(
                          name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'GilroyBold',
                            fontSize: 22,
                            height: 1.3,
                          ),
                        ),
                      ),

                      // ── Price ──────────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                        child: (Constants.op_discount != 0)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${Constants.op_discount_price} TMT',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'GilroyBold',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: Text(
                                      '${Constants.op_price} TMT',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Semi',
                                        color: Colors.grey.shade500,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '-${Constants.op_discount}%',
                                      style: const TextStyle(color: Colors.white, fontFamily: 'Semi', fontSize: 11),
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '${Constants.op_price} TMT',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'GilroyBold',
                                  color: Colors.black,
                                ),
                              ),
                      ),

                      // ── Divider ────────────────────────────────────────────
                      Container(
                        height: 1,
                        margin: const EdgeInsets.fromLTRB(18, 16, 18, 4),
                        color: Colors.grey.shade100,
                      ),

                      // ── Description (expandable + animated) ───────────────
                      GestureDetector(
                        onTap: () => setState(() {
                          descrip = !descrip;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Constants.ru_full_dep[prov.dil],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'GilroyBold',
                                  color: Colors.black,
                                ),
                              ),
                              AnimatedRotation(
                                turns: descrip ? 0.0 : -0.25,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        child: Visibility(
                          visible: descrip,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                            child: Html(
                              data: prov.dil == 1
                                  ? Constants.op_description_tm
                                  : prov.dil == 0
                                      ? Constants.op_description_ru
                                      : Constants.op_description_en,
                              style: {
                                "body": Style(
                                  backgroundColor: Colors.white,
                                  color: Colors.black87,
                                  fontFamily: 'GilroyMedium',
                                  lineHeight: const LineHeight(1.8),
                                  fontSize: FontSize.large,
                                ),
                                "p": Style(margin: Margins.all(1), padding: HtmlPaddings.all(1)),
                                "span": Style(fontFamily: 'GilroyMedium', fontSize: FontSize.medium),
                              },
                            ),
                          ),
                        ),
                      ),

                      // ── Sizes (expandable) ─────────────────────────────────
                      if (sizes.isNotEmpty) ...[
                        Container(height: 1, margin: const EdgeInsets.fromLTRB(18, 4, 18, 0), color: Colors.grey.shade100),
                        GestureDetector(
                          onTap: () => setState(() {
                            vis_size = !vis_size;
                          }),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(text_size, style: const TextStyle(fontSize: 18, fontFamily: 'GilroyBold', color: Colors.black)),
                                AnimatedRotation(
                                  turns: vis_size ? 0.0 : -0.25,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (vis_size)
                          SizedBox(
                            height: 54,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              itemCount: sizes.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(color: Colors.grey.shade200, spreadRadius: 2, blurRadius: 6)],
                                  ),
                                  child: Text(sizes[index], style: const TextStyle(fontFamily: 'Semi', fontSize: 14)),
                                );
                              },
                            ),
                          ),
                      ],

                      // ── Colors (expandable) ────────────────────────────────
                      if (colors.isNotEmpty) ...[
                        Container(height: 1, margin: const EdgeInsets.fromLTRB(18, 8, 18, 0), color: Colors.grey.shade100),
                        GestureDetector(
                          onTap: () => setState(() {
                            vis_color = !vis_color;
                          }),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prov.dil != 0 ? 'Reňkler' : 'Цвета',
                                  style: const TextStyle(fontSize: 18, fontFamily: 'GilroyBold', color: Colors.black),
                                ),
                                AnimatedRotation(
                                  turns: vis_color ? 0.0 : -0.25,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (vis_color)
                          SizedBox(
                            height: 54,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              itemCount: colors.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Constants.op_id = product[index].id;
                                      Constants.op_name_tm = product[index].name_tm;
                                      Constants.op_name_ru = product[index].name_ru;
                                      Constants.op_description_tm = product[index].description_tm;
                                      Constants.op_description_ru = product[index].description_ru;
                                      Constants.op_image = product[index].image;
                                      Constants.op_price = product[index].price;
                                      Constants.op_count = product[index].count;
                                      Constants.op_quantity_step = product[index].quantity_step;
                                      Constants.op_rating = product[index].rating;
                                      Constants.op_discount = product[index].discount;
                                      Constants.op_discount_price = product[index].discount_price;
                                      Constants.op_category = product[index].category;
                                      Constants.op_values = product[index].values;
                                    });
                                  },
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Color(int.parse('0xff${colors[index].colors.replaceAll("#", "")}')),
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4)],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        Container(height: 1, margin: const EdgeInsets.fromLTRB(18, 8, 18, 0), color: Colors.grey.shade100),
                      ],

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Cart button (always visible, pinned bottom) ─────────────────
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: _addCartButton(context),
          ),
        ],
      ),
    );
  }

  Widget _addCartButton(BuildContext context) {
    final bool inCart = Provider.of<ProvItem>(context).items[Constants.op_id]?.count != null;

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: inCart ? Colors.white : AppColors.primary,
      border: inCart ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
      boxShadow: [
        BoxShadow(
          color: inCart ? Colors.black.withOpacity(0.1) : AppColors.primary.withOpacity(0.4),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );

    if (inCart) {
      return Container(
        height: 62,
        decoration: decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Provider.of<ProvItem>(context, listen: false).removeItem(Constants.op_id, Constants.op_quantity_step),
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(CupertinoIcons.minus, color: Colors.white, size: 18),
              ),
            ),
            Text(
              formatQuantity(Provider.of<ProvItem>(context).items[Constants.op_id]!.count),
              style: const TextStyle(color: Colors.black, fontSize: 22, fontFamily: 'GilroyBold'),
            ),
            GestureDetector(
              onTap: () => Provider.of<ProvItem>(context, listen: false).addItem(
                Constants.op_id,
                Constants.op_name_tm,
                Constants.op_name_ru,
                Constants.op_name_en,
                Constants.op_description_tm,
                Constants.op_description_ru,
                Constants.op_description_en,
                Constants.op_image,
                Constants.op_price,
                Constants.op_quantity_step,
                Constants.op_rating,
                Constants.op_discount,
                Constants.op_discount_price,
                Constants.op_category,
                Constants.op_values,
                Constants.op_quantity_step,
              ),
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      );
    }

    // Sepette değil — tüm buton tıklanabilir
    return GestureDetector(
      onTap: () => Provider.of<ProvItem>(context, listen: false).addItem(
        Constants.op_id,
        Constants.op_name_tm,
        Constants.op_name_ru,
        Constants.op_name_en,
        Constants.op_description_tm,
        Constants.op_description_ru,
        Constants.op_description_en,
        Constants.op_image,
        Constants.op_price,
        Constants.op_quantity_step,
        Constants.op_rating,
        Constants.op_discount,
        Constants.op_discount_price,
        Constants.op_category,
        Constants.op_values,
        Constants.op_quantity_step,
      ),
      child: Container(
        height: 62,
        decoration: decoration,
        child: Center(
          child: Text(
            Constants.ru_AddCart[Provider.of<Which_page>(context).dil],
            style: const TextStyle(color: Colors.white, fontFamily: 'Semi', fontSize: 20),
          ),
        ),
      ),
    );
  }
}
