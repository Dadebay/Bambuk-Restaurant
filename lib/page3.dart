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
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final provItem = Provider.of<ProvItem>(context);
    final pageProvider = Provider.of<Which_page>(context);

    if (provItem.total_price > 0) {
      return ListView.builder(
        // padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        itemCount: provItem.myid.length,
        // separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, idx) {
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
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty.png', width: 180),
            const SizedBox(height: 20),
            Text(
              constants.ru_empty[pageProvider.dil],
              style: const TextStyle(fontFamily: gilroyMedium, fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    final provItem = Provider.of<ProvItem>(context);
    final pageProvider = Provider.of<Which_page>(context);
    if (provItem.total_price <= 0) return const SizedBox.shrink();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          _priceRow(
            constants.ru_product_price[pageProvider.dil],
            '${provItem.price.toStringAsFixed(2)} TMT',
          ),
          const SizedBox(height: 10),
          _priceRow(
            constants.ru_discount_info[pageProvider.dil],
            '- ${provItem.dis.toStringAsFixed(2)} TMT',
            valueColor: Colors.green,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _priceRow(
            constants.ru_net_price[pageProvider.dil],
            (provItem.price < pageProvider.dostawka_min) ? '${provItem.total_price} TMT' : '${provItem.total_price.toStringAsFixed(2)} TMT',
            labelStyle: const TextStyle(fontSize: 16, fontFamily: gilroyBold, color: Colors.black),
            valueStyle: TextStyle(fontSize: 18, fontFamily: gilroyBold, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (constants.token.isNotEmpty) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SendOrder()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Page4()));
              }
            },
            child: Container(
              height: 56,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(IconlyBold.bag_2, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    constants.ru_order[pageProvider.dil],
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: gilroyBold),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    (provItem.price < pageProvider.dostawka_min) ? '(${provItem.total_price} TMT)' : '(${provItem.total_price.toStringAsFixed(2)} TMT)',
                    style: const TextStyle(fontSize: 14, color: Colors.white70, fontFamily: gilroyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color? valueColor, TextStyle? labelStyle, TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? const TextStyle(fontSize: 14, fontFamily: gilroyMedium, color: Colors.black54)),
        Text(value, style: valueStyle ?? TextStyle(fontSize: 14, fontFamily: gilroyBold, color: valueColor ?? Colors.black)),
      ],
    );
  }
}
