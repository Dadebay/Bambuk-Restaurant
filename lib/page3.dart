// ignore_for_file:

import 'package:bamboo/my_pages3/karzina_card.dart';
import 'package:bamboo/my_pages3/send_order.dart';
import 'package:bamboo/page4.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import 'values/constants.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  bool sending_order = false;
  void update_order() {
    setState(() {
      sending_order = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);
    if (prov.dil != 0) {
      Constants.dil = true;
    } else {
      Constants.dil = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          Constants.ru_basket[Provider.of<Which_page>(context).dil],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: 'Semi',
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ProvItem>(context, listen: false).clearItem();
              },
              icon: const Icon(IconlyLight.delete))
        ],
      ),
      body: (Provider.of<ProvItem>(context).total_price > 0)
          ? Container(
              color: Colors.white,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate(List.generate(Provider.of<ProvItem>(context).myid.length, (idx) {
                    return KarzinaCard(
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.id,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.name_tm,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.name_ru,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.name_en,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.description_tm,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.description_ru,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.description_en,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.image,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.price,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.count,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.rating,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.discount,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.discount_price,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.category,
                        Provider.of<ProvItem>(context).items[Provider.of<ProvItem>(context).myid[idx]]!.values);
                  }))),

                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 25,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: AppColors.light_silver, borderRadius: BorderRadius.circular(20), border: Border.all(width: 2, color: AppColors.light_silver)),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Constants.ru_product_price[prov.dil],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Semi',
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    Provider.of<ProvItem>(context).price.toStringAsFixed(2) + ' TMT',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Semi',
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 25, bottom: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    Constants.ru_discount_info[prov.dil],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Semi',
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${Provider.of<ProvItem>(context).dis.toStringAsFixed(2)} TMT',
                                    style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Semi'),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: AppColors.primary,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  // ignore:
                                  Text(
                                    Constants.ru_net_price[prov.dil],
                                    style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Semi'),
                                  ),
                                  // ignore:
                                  Text(
                                    (Provider.of<ProvItem>(context).price < Provider.of<Which_page>(context).dostawka_min)
                                        ? '${(Provider.of<ProvItem>(context).total_price)}TMT'
                                        : '${Provider.of<ProvItem>(context).total_price.toStringAsFixed(2)} TMT',
                                    style: const TextStyle(fontSize: 18, color: AppColors.primary, fontFamily: gilroyBold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),

                  // ignore:
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 25,
                    ),
                  ),
                  // ignore:
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 25,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: (() {
                        if (Constants.token != '') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SendOrder()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Page4()));
                        }
                      }),
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              // ignore:
                              child: Text(
                                Constants.ru_order[prov.dil],
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Semi'),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              (Provider.of<ProvItem>(context).price < Provider.of<Which_page>(context).dostawka_min)
                                  ? '(${(Provider.of<ProvItem>(context).total_price)}TMT)'
                                  : '(${Provider.of<ProvItem>(context).total_price.toStringAsFixed(2)}TMT)',
                              style: const TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Semi'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ignore:
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 70,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      'assets/images/empty.png',
                    ),
                  ),
                  Text(
                    Constants.ru_empty[Provider.of<Which_page>(context).dil],
                    style: const TextStyle(fontFamily: 'Semi', fontSize: 16, color: Colors.black),
                  )
                ],
              ),
            ),
    );
  }
}
