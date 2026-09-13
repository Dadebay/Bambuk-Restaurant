import 'package:bamboo/values/call_helper.dart';
import 'package:bamboo/my_pages/cart_items.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MyFavourites extends StatefulWidget {
  const MyFavourites({super.key});

  @override
  _MyFavouritesState createState() => _MyFavouritesState();
}

class _MyFavouritesState extends State<MyFavourites> {
  int pindex = -2;
  @override
  Widget build(BuildContext context) {
    pindex = -2;
    var prov = Provider.of<Favourite>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: const SizedBox.shrink(),
        title: logo(),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => callRestaurant(context),
              icon: const Icon(
                IconlyBold.call,
                color: AppColors.primary,
              ))
        ],
      ),
      body: prov.myid.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/nodata.json',
                    width: 240,
                    height: 240,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Consumer<Which_page>(
                    builder: (context, wp, _) => Text(
                      Constants.emptyFavouritesTitle[wp.dil],
                      style: const TextStyle(
                        fontFamily: 'GilroyBold',
                        fontSize: 20,
                        color: Color(0xFF1A1A1A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<Which_page>(
                    builder: (context, wp, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        Constants.emptyFavouritesSubtitle[wp.dil],
                        style: const TextStyle(
                          fontFamily: 'GilroyMedium',
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              // Ak fon aýryldy: Scaffold dury (transparent), aşakdaky
              // bambuk suraty görünmeli - ak gutujyk ony ýapýardy.
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: LayoutBuilder(builder: (context, box) {
                // Kartyň suraty kwadrat (AspectRatio 1.0), şonuň üçin kartyň
                // boýy onuň inliligine bagly. Planşetde 2 sütünde öýjük
                // 497dp bolup, 315dp-lik beýiklige sygman daşyna çykýardy.
                final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
                final int cross = isTablet ? 3 : 2;
                final double spacing = isTablet ? 14 : 0;
                final double cellW = (box.maxWidth - spacing * (cross - 1)) / cross;
                // ýazgy zolagy: gyralar + bir setir at + aralyk + düwme
                final double extent = isTablet ? cellW + 92 : 315;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    mainAxisExtent: extent,
                  ),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  primary: false,
                  itemCount: prov.myid.length,
                  itemBuilder: (context, index) {
                    return CartItems(
                        prov.items[prov.myid[index]]!.id,
                        prov.items[prov.myid[index]]!.name_tm,
                        prov.items[prov.myid[index]]!.name_ru,
                        prov.items[prov.myid[index]]!.name_en,
                        prov.items[prov.myid[index]]!.description_tm,
                        prov.items[prov.myid[index]]!.description_ru,
                        prov.items[prov.myid[index]]!.description_en,
                        prov.items[prov.myid[index]]!.image,
                        prov.items[prov.myid[index]]!.price,
                        prov.items[prov.myid[index]]!.count,
                        prov.items[prov.myid[index]]!.rating,
                        prov.items[prov.myid[index]]!.discount,
                        prov.items[prov.myid[index]]!.discount_price,
                        prov.items[prov.myid[index]]!.category,
                        prov.items[prov.myid[index]]!.values,
                        quantity_step: prov.items[prov.myid[index]]!.quantity_step);
                  });
              }),
            ),
    );
  }
}
