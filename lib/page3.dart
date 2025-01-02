// ignore_for_file: file_names, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:bamboo/my_pages3/karzina_card.dart';
import 'package:bamboo/my_pages3/send_order.dart';
import 'package:bamboo/page4.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
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
  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<Which_page>(context);
    constants.dil = pageProvider.dil != 0; //Dil seçimini constants'a aktar

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          constants.ru_basket[pageProvider.dil],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: gilroyBold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Provider.of<ProvItem>(context, listen: false).clearItem(),
            icon: const Icon(IconlyLight.delete),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final provItem = Provider.of<ProvItem>(context);
    final pageProvider = Provider.of<Which_page>(context);

    if (provItem.total_price > 0) {
      return Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                List.generate(provItem.myid.length, (idx) {
                  final itemId = provItem.myid[idx];
                  final item = provItem.items[itemId]!;
                  return KarzinaCard(
                    item.id,
                    item.name_tm,
                    item.name_ru,
                    item.name_en,
                    item.description_tm,
                    item.description_ru,
                    item.description_en,
                    item.image,
                    item.price,
                    item.count,
                    item.rating,
                    item.discount,
                    item.discount_price,
                    item.category,
                    item.values,
                  );
                }),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 25,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildTotalPriceCard(context),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 25,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 25,
              ),
            ),
            SliverToBoxAdapter(
              child: _buildOrderButton(context),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 70,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
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
              constants.ru_empty[pageProvider.dil],
              style: const TextStyle(fontFamily: 'Semi', fontSize: 16, color: Colors.black),
            )
          ],
        ),
      );
    }
  }

  Widget _buildTotalPriceCard(BuildContext context) {
    final provItem = Provider.of<ProvItem>(context);
    final pageProvider = Provider.of<Which_page>(context);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.light_silver, borderRadius: BorderRadius.circular(20), border: Border.all(width: 2, color: AppColors.light_silver)),
      child: Column(
        children: [
          _buildPriceRow(constants.ru_product_price[pageProvider.dil], '${provItem.price.toStringAsFixed(2)} TMT'),
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 25),
            child: _buildPriceRow(constants.ru_discount_info[pageProvider.dil], '${provItem.dis.toStringAsFixed(2)} TMT'),
          ),
          Divider(
            thickness: 1,
            color: AppColors.primary,
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: _buildPriceRow(
              constants.ru_net_price[pageProvider.dil],
              (provItem.price < pageProvider.dostawka_min) ? '${provItem.total_price}TMT' : '${provItem.total_price.toStringAsFixed(2)} TMT',
              priceTextStyle: TextStyle(fontSize: 18, color: AppColors.primary, fontFamily: gilroyBold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {TextStyle? priceTextStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Semi',
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: priceTextStyle ??
              TextStyle(
                fontSize: 16,
                fontFamily: 'Semi',
                color: Colors.black,
              ),
        ),
      ],
    );
  }

  Widget _buildOrderButton(BuildContext context) {
    final provItem = Provider.of<ProvItem>(context);
    final pageProvider = Provider.of<Which_page>(context);

    return GestureDetector(
      onTap: () {
        if (constants.token.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SendOrder()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Page4()),
          );
        }
      },
      child: Container(
        height: 60,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20),
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
              child: Text(
                constants.ru_order[pageProvider.dil],
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Semi'),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              (provItem.price < pageProvider.dostawka_min) ? '(${provItem.total_price}TMT)' : '(${provItem.total_price.toStringAsFixed(2)}TMT)',
              style: const TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Semi'),
            ),
          ],
        ),
      ),
    );
  }
}
