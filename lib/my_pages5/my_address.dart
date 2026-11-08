import 'package:bamboo/providers/favourite.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;

import 'add_adress.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  _MyAddressState createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconlyLight.arrow_left_circle, color: Colors.black),
        ),
        title: Text(
          Constants.ru_address[Provider.of<Which_page>(context).dil],
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: ListView(
          children: [
            (Provider.of<Favourite>(context).address.isNotEmpty)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: Provider.of<Favourite>(context).address.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Icon(
                                    IconlyLight.location,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 20,
                                            top: 10,
                                            bottom: 10,
                                            right: 10),
                                        child: Text(
                                          Provider.of<Favourite>(context)
                                              .address[index]
                                              .name,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Semi'),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 20, bottom: 10, right: 10),
                                        child: Text(
                                          Provider.of<Favourite>(context)
                                              .address[index]
                                              .address_txt,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddAddress()),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 52,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      Constants.ru_addNew[Provider.of<Which_page>(context).dil],
                      style: const TextStyle(
                          color: AppColors.primary, fontFamily: 'Semi'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
