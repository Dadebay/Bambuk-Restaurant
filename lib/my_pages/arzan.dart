import 'package:bamboo/my_pages/cart_items.dart';
import 'package:bamboo/my_pages/page1_all.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';
import '../values/models.dart';

// ignore: must_be_immutable
class MainVisibles extends StatefulWidget {
  int type;
  List<products> items;
  MainVisibles({
    super.key,
    required this.type,
    required this.items,
  });

  @override
  _MainVisiblesState createState() => _MainVisiblesState();
}

class _MainVisiblesState extends State<MainVisibles> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    return Column(
      children: [
        // ── Section header (page1 stiliyle) ──────────────────────────────
        Padding(
          padding: const EdgeInsets.only(left: 17, right: 15, top: 30, bottom: 10),
          child: Row(
            children: [
              // İkon kutusu — type'a göre farklı ikon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.type == 0
                      ? Icons.local_offer_rounded // indirim
                      : widget.type == 1
                          ? Icons.auto_awesome_rounded // yeni ürün
                          : Icons.whatshot_rounded, // hit
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Başlık + alt yazı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.type == 0
                          ? Constants.ru_discounts_products[prov.dil]
                          : widget.type == 1
                              ? Constants.ru_newBlud[prov.dil]
                              : Constants.ru_hitBlud[prov.dil],
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'GilroyBold',
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.type == 0
                          ? ['Лучшие предложения', 'Iň gowy teklipler', 'Best offers'][prov.dil]
                          : widget.type == 1
                              ? ['Только что добавлено', 'Täze goşulanlar', 'Just added'][prov.dil]
                              : ['Самые популярные', 'Iň meşhurlar', 'Most popular'][prov.dil],
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Monto',
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // "Tümünü gör" butonu
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page1All(
                        type: widget.type,
                        items: widget.items,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Constants.ru_show_all[prov.dil],
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Semi',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        IconlyLight.arrow_right_2,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Builder(builder: (context) {
          // Halanýanlar sahypasyndaky kart bilen deň ölçeg: kartyň suraty
          // kwadrat, şonuň üçin boýy = ini + ýazgy zolagy (~92dp: gyralar +
          // bir setir at + aralyk + 44dp düwme). Öňki 250x375 kartda at
          // sygman kesilýärdi we aşakda boş ak ýer galýardy.
          final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
          final double cardW = isTablet ? 300 : 180;

          return Container(
            height: isTablet ? cardW + 92 : 290,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 15),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: cardW,
                  child: CartItems(
                      widget.items[index].id,
                      widget.items[index].name_tm,
                      widget.items[index].name_ru,
                      widget.items[index].name_en,
                      widget.items[index].description_tm,
                      widget.items[index].description_ru,
                      widget.items[index].description_en,
                      widget.items[index].image,
                      widget.items[index].price,
                      widget.items[index].count,
                      widget.items[index].rating,
                      widget.items[index].discount,
                      widget.items[index].discount_price,
                      widget.items[index].category,
                      widget.items[index].values,
                      quantity_step: widget.items[index].quantity_step),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
