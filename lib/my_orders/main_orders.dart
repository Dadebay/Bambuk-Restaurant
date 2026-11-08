import 'package:bamboo/my_orders/activ.dart';
import 'package:bamboo/my_orders/disactiv.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../providers/page1settings.dart';

class MainOrders extends StatefulWidget {
  const MainOrders({super.key});

  @override
  _MainOrdersState createState() => _MainOrdersState();
}

class _MainOrdersState extends State<MainOrders> {
  bool aktiw = true;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<PageSettings>(context).page == 1) {
      Navigator.pop(context);
    }
    final prov = Provider.of<Which_page>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
        ),
        title: Text(
          Constants.ru_orders[prov.dil],
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, decoration: NeonStyle.bottomLine),
        ),
      ),
      body: Column(
        children: [
          // Tab switcher
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTab(Constants.ru_active[prov.dil], true),
                  _buildTab(Constants.ru_oldOrder[prov.dil], false),
                ],
              ),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: aktiw ? const Activ() : const Disactiv(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    final selected = aktiw == isActive;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => aktiw = isActive),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(3),
          alignment: Alignment.center,
          decoration: selected
              ? NeonStyle.selected(radius: 10)
              : BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: selected ? 'Semi' : 'GilroyRegular',
              fontSize: 14,
              color: selected ? AppColors.neon : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
