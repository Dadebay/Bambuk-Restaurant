import 'package:bamboo/my_pages/cart_items.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/widgets.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: const SizedBox.shrink(),
        title: logo(),
        centerTitle: true,
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
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 315, // here set custom Height You Want
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
                  prov.items[prov.myid[index]]!.values);
            }),
      ),
    );
  }
}
