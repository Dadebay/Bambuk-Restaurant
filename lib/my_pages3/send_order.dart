import 'dart:convert';

import 'package:bamboo/my_pages3/webview.dart';
import 'package:bamboo/providers/favourite.dart';
import 'package:flutter/material.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../providers/bottom_prov.dart';

class SendOrder extends StatefulWidget {
  const SendOrder({super.key});

  // ignore: non_constant_identifier_names

  @override
  _SendOrderState createState() => _SendOrderState();
}

class _SendOrderState extends State<SendOrder> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    sendAddress =
        TextEditingController(text: Provider.of<Favourite>(context, listen: false).address.isNotEmpty ? Provider.of<Favourite>(context, listen: false).address[which_address].address_txt : '');
    controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  TextEditingController sendPhone = TextEditingController(text: Constants.phone);
  TextEditingController sendName = TextEditingController(text: Constants.name);
  TextEditingController sendAddress = TextEditingController();
  TextEditingController sendDate = TextEditingController();
  TextEditingController sendTime = TextEditingController();
  TextEditingController sendType = TextEditingController();
  TextEditingController sendNote = TextEditingController();
  TextEditingController timeCtl = TextEditingController();

  List<String> listBank = ['Halk bank', 'Senagat bank', 'Rysgal bank', 'Wnesheconom bank'];
  int loader = 0;
  int selectBank = 0;
  String dropdownValue = (Constants.dil != false) ? 'Aşgabat' : 'Ашхабад';
  int which = 0;
  int ii = 1;
  int type_order = 1;
  int dostawka_type = 1;
  int which_address = 0;
  bool selectBonus = false;
  _launchURL(String ads) async {
    final Uri url = Uri.parse(ads);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> sending(String phone, String address, String date, String time, String type, String note, int dostawType, String timer, BuildContext context) async {
    try {
      if ((address.isEmpty && type_order == 2)) {
        setState(() {
          loader = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Maglumaty doly dolduryň!"),
        ));
      } else {
        if (timer.isEmpty) {
          DateTime now = DateTime.now();
          timer = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
        }
        var url = Uri.https(Constants.api, '/api/v1/orders');
        var token = Constants.token;
        var prov = Provider.of<ProvItem>(context, listen: false);
        Map<String, String> data = {
          "full_name": Constants.name,
          "phone": Constants.phone,
          "address": type_order == 2 ? address : "No address",
          "note": note,
          "delivery_type": '$type_order',
          "delivery_time": timer,
          "payment_method": ii.toString(),
          "location": "1"
        };
        if (ii == 1 && selectBonus) {
          data["is_bonus_used"] = "1";
        }
        if (ii == 3) {
          if (selectBank == 0) {
            data["bank"] = "halk";
          } else if (selectBank == 1) {
            data["bank"] = "senagat";
          } else if (selectBank == 2) {
            data["bank"] = "rysgal";
          } else if (selectBank == 3) {
            data["bank"] = "vnesh";
          }
        }
        for (int i = 0; i < prov.myid.length; i++) {
          data['cart_product_ids[${prov.items[prov.myid[i]]!.id}]'] = prov.items[prov.myid[i]]!.count.toString();
        }
        Map<String, String> headers = {'Authorization': 'Bearer $token'};
        var req = http.MultipartRequest('POST', url)
          ..fields.addAll(data)
          ..headers.addAll(headers);
        var res = await req.send();

        if (res.statusCode == 201 || res.statusCode == 200) {
          Provider.of<Which_page>(context, listen: false).increment_cart();
          Provider.of<ProvItem>(context, listen: false).clearItem();
          var response = await http.Response.fromStream(res);
          var mcat = json.decode(utf8.decode(response.bodyBytes));
          if (ii == 3) {
            _dialogBuilder(context);
            _launchURL(mcat);
          } else {
            _dialogBuilder(context);
          }
          setState(() {
            loader = 0;
          });
        } else {
          setState(() {
            loader = 0;
          });
        }
      }
    } catch (_) {
      setState(() {
        loader = 0;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context, listen: false);
    var provDil = Provider.of<Which_page>(context).dil;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: AppColors.appBar_back),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    Constants.ru_send[provDil],
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
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
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(left: 5, right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.light_silver,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/back.svg',
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(100),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            const SizedBox(height: 25),
            TextFormField(
              controller: timeCtl, // add this line.
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                hintText: '** **',
                labelText: Constants.ru_timeDos[prov.dil],
                // ignore: prefer_const_constructors
                labelStyle: TextStyle(fontSize: 10, color: Colors.black),
              ),
              onTap: () async {
                TimeOfDay time = TimeOfDay.now();
                FocusScope.of(context).requestFocus(FocusNode());

                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (picked != null && picked != time) {
                  timeCtl.text = picked.toString().substring(0, picked.toString().length - 1);
                  timeCtl.text = timeCtl.text.replaceAll('TimeOfDay(', '');
                  // add this line.
                  setState(() {
                    time = picked;
                  });
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'cant be empty';
                }
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 25),
              height: 1,
              color: AppColors.silver,
            ),
            Text(
              Constants.ru_dosType[provDil],
              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type_order = 1;
                      });
                    },
                    child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 15.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/language_selected.svg',
                              color: (type_order == 1) ? AppColors.primary : AppColors.silver,
                              allowDrawingOutsideViewBox: true,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                Constants.ru_wynos[provDil],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Semi',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  // ignore: prefer_const_constructors

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          margin: const EdgeInsets.all(20),
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.down,
                          duration: const Duration(seconds: 3),
                          backgroundColor: AppColors.primary,
                          content: Text(
                            Constants.ru_textr[provDil],
                            //товар удален из вашей корзины
                            style: const TextStyle(color: Colors.white),
                          ),
                        ));
                        type_order = 2;
                      });
                    },
                    child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 15.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/language_selected.svg',
                              color: (type_order == 2) ? AppColors.primary : AppColors.silver,
                              allowDrawingOutsideViewBox: true,
                            ),
                            Container(
                              width: 95,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                Constants.ru_sargamak[provDil],
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Semi',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  // ignore: prefer_const_constructors
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        type_order = 3;
                      });
                    },
                    child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/language_selected.svg',
                              // ignore: deprecated_member_use
                              color: (type_order == 3) ? AppColors.primary : AppColors.silver,
                              allowDrawingOutsideViewBox: true,
                            ),
                            Container(
                              width: 95,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                Constants.ru_bron[provDil],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Semi',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: AppColors.silver,
            ),
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 5),
              child: Text(
                Constants.ru_type[provDil],
                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ii = 1;
                      });
                    },
                    child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 15.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/language_selected.svg',
                              color: (ii == 1) ? AppColors.primary : AppColors.silver,
                              allowDrawingOutsideViewBox: true,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                Constants.ru_cash[provDil],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Semi',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  // ignore: prefer_const_constructors

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ii = 2;
                      });
                    },
                    child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 5.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/language_selected.svg',
                              // ignore: deprecated_member_use
                              color: (ii == 2) ? AppColors.primary : AppColors.silver,
                              allowDrawingOutsideViewBox: true,
                            ),
                            Container(
                              width: 95,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                Constants.ru_kart[provDil],
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Semi',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  // ignore: prefer_const_constructors

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ii = 3;
                      });
                    },
                    child: Container(
                        height: 60,
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/language_selected.svg',
                              color: (ii == 3) ? AppColors.primary : AppColors.silver,
                              allowDrawingOutsideViewBox: true,
                            ),
                            Container(
                              width: 95,
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                Constants.ru_online[provDil],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Semi',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: AppColors.silver,
            ),
            Visibility(
              visible: ii == 1,
              child: Container(
                margin: const EdgeInsets.only(top: 25, bottom: 5),
                child: Text(
                  Constants.ru_use_bonus[provDil],
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
                ),
              ),
            ),
            Visibility(
              visible: ii == 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectBonus = !selectBonus;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15, top: 15),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/language_selected.svg',
                        color: (selectBonus) ? AppColors.primary : AppColors.silver,
                        allowDrawingOutsideViewBox: true,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "${Constants.bonusMoney} TMT",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Semi',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: ii == 1,
              child: Container(
                height: 1,
                color: AppColors.silver,
              ),
            ),
            Visibility(
              visible: ii == 3,
              child: Container(
                margin: const EdgeInsets.only(top: 25, bottom: 5),
                child: Text(
                  Constants.ru_selectBank[provDil],
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
                ),
              ),
            ),
            Visibility(
              visible: ii == 3,
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listBank.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectBank = index;
                        });
                      },
                      child: Container(
                          height: 60,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 15.0),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/language_selected.svg',
                                color: (selectBank == index) ? AppColors.primary : AppColors.silver,
                                allowDrawingOutsideViewBox: true,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  listBank[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Semi',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: ii == 3,
              child: Container(
                height: 1,
                color: AppColors.silver,
              ),
            ),
            Visibility(
              visible: type_order == 2,
              child: const SizedBox(
                height: 25,
              ),
            ),
            Visibility(
              visible: type_order == 2,
              child: Text(
                Constants.ru_address[provDil],
                style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
              ),
            ),
            Visibility(
              visible: type_order == 2,
              child: Provider.of<Favourite>(context).address.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 60, // here set custom Height You Want
                      ),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      primary: false,
                      itemCount: Provider.of<Favourite>(context).address.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              which_address = index;
                              sendAddress = TextEditingController(text: Provider.of<Favourite>(context, listen: false).address[index].address_txt);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/language_selected.svg',
                                  color: (which_address == index) ? AppColors.primary : AppColors.silver,
                                  allowDrawingOutsideViewBox: true,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      Provider.of<Favourite>(context).address[index].name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Semi',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                  : Container(),
            ),
            Visibility(
              visible: type_order == 2,
              child: const SizedBox(
                height: 25,
              ),
            ),
            Visibility(
              visible: type_order == 2,
              child: SizedBox(
                height: 150,
                child: TextField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  // ignore: prefer_const_constructors
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  // ignore: prefer_const_constructors
                  controller: sendAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),

                    labelText: Constants.ru_adres[provDil],
                    // ignore: prefer_const_constructors
                    labelStyle: TextStyle(fontSize: 16, fontFamily: 'Semi', color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Visibility(
              visible: true,
              child: TextField(
                // ignore: prefer_const_constructors
                controller: sendNote,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),

                  labelText: Constants.ru_note[provDil],
                  // ignore: prefer_const_constructors
                  labelStyle: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              height: 1,
              color: AppColors.silver,
            ),
            const SizedBox(height: 25),
            Container(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                decoration: BoxDecoration(color: AppColors.light_silver, borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: AppColors.light_silver)),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            Constants.ru_product_price[provDil],
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Semi',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            Provider.of<ProvItem>(context).price.toStringAsFixed(2) + 'TMT',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Semi',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Visibility(
                      visible: type_order == 2,
                      child: const SizedBox(
                        height: 25,
                      ),
                    ),

                    Visibility(
                      visible: type_order == 2,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              Constants.ru_extra_info[provDil],
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Semi',
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              (Provider.of<ProvItem>(context).price > Provider.of<Which_page>(context).dostawka_min)
                                  ? '0 TMT'
                                  : '${Provider.of<Which_page>(context).dostawka_price.toStringAsFixed(2)}TMT',
                              style: const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Semi'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ignore: prefer_const_constructors

                    const SizedBox(
                      height: 25,
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            Constants.ru_discount_info[provDil],
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Semi',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${Provider.of<ProvItem>(context).dis.toStringAsFixed(2)}TMT',
                            style: const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Semi'),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: selectBonus,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              Constants.ru_bonus[provDil],
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Semi',
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${Constants.bonusMoney} TMT',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Semi',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    Container(
                      height: 2,
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                        color: AppColors.silver,
                      ),
                      child: const Divider(
                        height: 2,
                        color: AppColors.silver,
                      ),
                    ),

                    // ignore: prefer_const_constructors

                    const SizedBox(
                      height: 25,
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // ignore: prefer_const_constructors
                          Text(
                            Constants.ru_net_price[provDil],
                            style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: 'Semi'),
                          ),
                          // ignore: prefer_const_constructors
                          Text(
                            selectBonus
                                ? (Provider.of<ProvItem>(context).price < Provider.of<Which_page>(context).dostawka_min)
                                    ? '${(Provider.of<ProvItem>(context).total_price + Provider.of<Which_page>(context).dostawka_price - double.parse(Constants.bonusMoney)).toStringAsFixed(2)}TMT'
                                    : '${(Provider.of<ProvItem>(context).total_price - double.parse(Constants.bonusMoney)).toStringAsFixed(2)}TMT'
                                : (Provider.of<ProvItem>(context).price < Provider.of<Which_page>(context).dostawka_min)
                                    ? type_order == 2
                                        ? '${(Provider.of<ProvItem>(context).total_price + Provider.of<Which_page>(context).dostawka_price).toStringAsFixed(2)}TMT'
                                        : '${(Provider.of<ProvItem>(context).total_price).toStringAsFixed(2)}TMT'
                                    : '${(Provider.of<ProvItem>(context).total_price).toStringAsFixed(2)}TMT',
                            style: const TextStyle(fontSize: 16, color: Colors.green, fontFamily: 'Semi'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: (() {
                        if (loader == 0) {
                          setState(() {
                            loader = 1;
                          });
                          sending(sendPhone.text, sendAddress.text, sendDate.text, sendTime.text, dropdownValue, sendNote.text, dostawka_type, timeCtl.text, context);
                        }
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // ignore: prefer_const_constructors
                        child: loader == 0
                            ? Text(
                                Constants.ru_confirm[provDil],
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Semi'),
                              )
                            : LinearProgressIndicator(
                                minHeight: 15,
                                value: animation.value,
                                color: AppColors.light_silver,
                                backgroundColor: AppColors.primary,
                                semanticsLabel: 'Linear progress indicator',
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            SizedBox(
              width: 500,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Constants.ru_razmeshon[Provider.of<Which_page>(context).dil],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.primary, fontSize: 20, fontFamily: 'Semi'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.only(right: 30),
                    child: Image.asset('assets/images/good_order.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Constants.ru_potwerdit[Provider.of<Which_page>(context).dil],
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Provider.of<BottomProv>(context, listen: false).set_page0();
                        Navigator.pop(context);

                        //  Navigator.push(
                        //      context,
                        //      MaterialPageRoute(
                        //          builder: (context) => MainOrders()));
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        color: AppColors.primary,
                        child: Text(
                          Constants.ru_contin[Provider.of<Which_page>(context).dil],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontFamily: 'Semi'),
                        ),
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
