import 'package:bamboo/DB/db.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';
import '../values/colors.dart';
import 'package:bamboo/values/constants.dart' as Constants;

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController address_name = TextEditingController();
  TextEditingController address = TextEditingController();
  Future<void> sending(String addressName1, String address1, BuildContext context) async {
    try {
      if (address1 != '' && addressName1 != '') {
        DatabaseHelper.add_address(addressName1, address1);
        Provider.of<Favourite>(context, listen: false).addAddress(addressName1, address1);
        setState(() {
          address.clear();
          address_name.clear();
        });
      } else {}
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: AppColors.appBar_back),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    Constants.ru_address[Provider.of<Which_page>(context).dil],
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 55,
                        width: 55,
                        color: const Color.fromARGB(0, 255, 255, 255),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
        child: ListView(
          children: [
            Text(
              Constants.ru_addSal[Provider.of<Which_page>(context).dil],
              style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: address_name,
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 20),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2.0), gapPadding: 6.0),
                enabledBorder: OutlineInputBorder(gapPadding: 6.0, borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                labelText: (Provider.of<Which_page>(context).dil != 0) ? 'Salgynyň ady' : 'Название адреса',
                labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 200,
              child: TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                controller: address,
                expands: true,
                maxLines: null,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2.0), gapPadding: 6.0),
                  enabledBorder: OutlineInputBorder(gapPadding: 6.0, borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                  labelText: Constants.ru_adres[Provider.of<Which_page>(context).dil],
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                sending(address_name.text, address.text, context);
              },
              child: Container(
                height: 60,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 35),
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
                        Constants.ru_addSal[Provider.of<Which_page>(context).dil],
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Semi'),
                      ),
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
