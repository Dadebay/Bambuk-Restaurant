// ignore_for_file: non_constant_identifier_names, camel_case_types, use_build_context_synchronously

import 'dart:convert';

import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/bottom_prov.dart';

class locations {
  final int id;
  final String name_tm;
  final String name_ru;
  final String name_en;
  final String min_order_fee;
  final String shipping_fee;

  locations({
    required this.id,
    required this.name_tm,
    required this.name_ru,
    required this.name_en,
    required this.min_order_fee,
    required this.shipping_fee,
  });
}

class SendOrder extends StatefulWidget {
  const SendOrder({super.key});

  @override
  _SendOrderState createState() => _SendOrderState();
}

class _SendOrderState extends State<SendOrder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final TextEditingController _sendAddress = TextEditingController();
  final TextEditingController _sendNote = TextEditingController();
  final TextEditingController _timeCtl = TextEditingController();

  final List<String> _listBank = ['Halk bank', 'Senagat bank', 'Rysgal bank', 'Wnesheconom bank'];
  int _loader = 0;
  int _selectBank = 0;
  int _ii = 1;
  int _typeOrder = 1;
  int _whichAddress = 0;
  bool _selectBonus = false;
  List<locations> _locations = [];
  locations? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _sendAddress.text = Provider.of<Favourite>(context, listen: false).address.isNotEmpty ? Provider.of<Favourite>(context, listen: false).address[_whichAddress].address_txt : '';
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final response = await _get('/api/v1/locations');
      if (response != null && response['data'] != null) {
        final locationsData = response['data'] as List<dynamic>;
        setState(() {
          _locations = locationsData
              .map((location) => locations(
                  id: location['id'],
                  name_tm: location['name_tm'] ?? '',
                  name_ru: location['name_ru'] ?? '',
                  name_en: location['name_en'] ?? '',
                  min_order_fee: location['min_order_fee'],
                  shipping_fee: location['shipping_fee']))
              .toList();
          if (_locations.isNotEmpty) {
            _selectedLocation = _locations[0];
          }
        });
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  Future<dynamic> _get(String url) async {
    try {
      final response = await http.get(Uri.https(constants.api, url));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print('Error fetching data from $url: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  _launchURL(String ads) async {
    final Uri url = Uri.parse(ads);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _sendOrder(BuildContext context) async {
    try {
      if ((_sendAddress.text.isEmpty && _typeOrder == 2)) {
        _showErrorSnackBar(context, "Maglumaty doly dolduryň!");
      } else {
        String timer = _timeCtl.text.isEmpty ? _getCurrentTime() : _timeCtl.text;
        var url = Uri.https(constants.api, '/api/v1/orders');
        var token = constants.token;
        var prov = Provider.of<ProvItem>(context, listen: false);
        Map<String, String> data = {
          "full_name": constants.name,
          "phone": constants.phone,
          "address": _typeOrder == 2 ? _sendAddress.text : "No address",
          "note": _sendNote.text,
          "delivery_type": '$_typeOrder',
          "delivery_time": timer,
          "payment_method": _ii.toString(),
          "location": _selectedLocation?.id.toString() ?? "1" // Seçilen lokasyonun ID'si
        };
        if (_ii == 1 && _selectBonus) {
          data["is_bonus_used"] = "1";
        }
        if (_ii == 3) {
          data["bank"] = _getSelectedBank();
        }
        for (int i = 0; i < prov.myid.length; i++) {
          data['cart_product_ids[${prov.items[prov.myid[i]]!.id}]'] = prov.items[prov.myid[i]]!.count.toString();
        }
        Map<String, String> headers = {'Authorization': 'Bearer $token'};
        var req = http.MultipartRequest('POST', url)
          ..fields.addAll(data)
          ..headers.addAll(headers);
        var res = await req.send();
        _handleResponse(res, context);
      }
    } catch (_) {
      _setLoaderFalse();
      rethrow;
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    setState(() {
      _loader = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss \n EEE d MMM').format(now);
  }

  String _getSelectedBank() {
    if (_selectBank == 0) return "halk";
    if (_selectBank == 1) return "senagat";
    if (_selectBank == 2) return "rysgal";
    if (_selectBank == 3) return "vnesh";
    return "";
  }

  Future<void> _handleResponse(http.StreamedResponse res, BuildContext context) async {
    if (res.statusCode == 201 || res.statusCode == 200) {
      Provider.of<Which_page>(context, listen: false).increment_cart();
      Provider.of<ProvItem>(context, listen: false).clearItem();
      var response = await http.Response.fromStream(res);
      var mcat = json.decode(utf8.decode(response.bodyBytes));
      if (_ii == 3) {
        _showOrderConfirmationDialog(context);
        _launchURL(mcat);
      } else {
        _showOrderConfirmationDialog(context);
      }
      _setLoaderFalse();
    } else {
      _setLoaderFalse();
    }
  }

  void _setLoaderFalse() {
    setState(() {
      _loader = 0;
    });
  }

  Future<void> _showOrderConfirmationDialog(BuildContext context) {
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
                    constants.ru_razmeshon[Provider.of<Which_page>(context).dil],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.primary, fontSize: 20, fontFamily: 'Semi'),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.only(right: 30),
                    child: Image.asset('assets/images/good_order.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    constants.ru_potwerdit[Provider.of<Which_page>(context).dil],
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                      onTap: () {
                        Provider.of<BottomProv>(context, listen: false).set_page0();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        color: AppColors.primary,
                        child: Text(
                          constants.ru_contin[Provider.of<Which_page>(context).dil],
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

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<Which_page>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          constants.ru_send[pageProvider.dil],
          style: const TextStyle(fontFamily: gilroyMedium, color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100, top: 25),
        children: [
          _buildTimeSelectionField(context, pageProvider),
          _buildTypeOfSargyt(pageProvider.dil, context),
          _buildTypeOfPayment(pageProvider.dil),
          _buildDivider(),
          _buildBonusSelection(pageProvider.dil),
          _buildBankSelection(pageProvider.dil),
          _buildAddressSection(pageProvider.dil, context),
          _buildNoteField(pageProvider.dil),
          _buildPriceInfo(context, pageProvider.dil),
          _buildSendButton(context, pageProvider),
        ],
      ),
    );
  }

  Widget _buildLocationDropdown(int provDil) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.25))),
      child: DropdownButton<locations>(
        isExpanded: true,
        hint: const Text(
          "Select Location",
          style: TextStyle(color: Colors.grey),
        ),
        value: _selectedLocation,
        items: _locations.map((location) {
          return DropdownMenuItem<locations>(
              value: location,
              child: Text(constants.dil == true
                  ? "${location.name_tm} (${location.shipping_fee} TMT)"
                  : (constants.dil == false ? "${location.name_ru} (${location.shipping_fee} TMT)" : "${location.name_en} (${location.shipping_fee} TMT)")));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedLocation = value;
          });
        },
        underline: Container(),
      ),
    );
  }

  Widget _buildTimeSelectionField(BuildContext context, Which_page pageProvider) {
    return TextFormField(
      controller: _timeCtl,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
        labelText: constants.ru_timeDos[pageProvider.dil],
        labelStyle: const TextStyle(fontSize: 16, fontFamily: gilroyMedium, color: Colors.grey),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
        );
        if (pickedDate != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            DateTime selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            _timeCtl.text = DateFormat('dd.MM.yyyy kk:mm').format(selectedDateTime);
          }
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'cant be empty';
        }
        return null;
      },
    );
  }

  Column _buildTypeOfPayment(int provDil) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDivider(),
        Text(
          constants.ru_type[provDil],
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
        ),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildPaymentTypeItem(1, constants.ru_cash[provDil], provDil),
              _buildPaymentTypeItem(2, constants.ru_kart[provDil], provDil),
              _buildPaymentTypeItem(3, constants.ru_online[provDil], provDil),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector _buildPaymentTypeItem(int type, String label, int provDil) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _ii = type;
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
                color: (_ii == type) ? AppColors.primary : AppColors.silver,
                allowDrawingOutsideViewBox: true,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  label,
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
  }

  Widget _buildBonusSelection(int provDil) {
    return Visibility(
      visible: _ii == 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 5),
            child: Text(
              constants.ru_use_bonus[provDil],
              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectBonus = !_selectBonus;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15, top: 15),
              color: Colors.transparent,
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/language_selected.svg',
                    color: (_selectBonus) ? AppColors.primary : AppColors.silver,
                    allowDrawingOutsideViewBox: true,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "${constants.bonusMoney} TMT",
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
          _buildDivider()
        ],
      ),
    );
  }

  Widget _buildBankSelection(int provDil) {
    return Visibility(
      visible: _ii == 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25, bottom: 5),
            child: Text(
              constants.ru_selectBank[provDil],
              style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _listBank.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectBank = index;
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
                            color: (_selectBank == index) ? AppColors.primary : AppColors.silver,
                            allowDrawingOutsideViewBox: true,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              _listBank[index],
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
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildTypeOfSargyt(int provDil, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDivider(),
        Text(
          constants.ru_dosType[provDil],
          style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: gilroyBold),
        ),
        SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildOrderTypeItem(1, constants.ru_wynos[provDil], provDil),
              _buildOrderTypeItem(2, constants.ru_sargamak[provDil], provDil, context),
              _buildOrderTypeItem(3, constants.ru_bron[provDil], provDil),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector _buildOrderTypeItem(int type, String label, int provDil, [BuildContext? context]) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _typeOrder = type;
          if (type == 2 && context != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              margin: const EdgeInsets.all(20),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.down,
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.primary,
              content: Text(
                constants.ru_textr[provDil],
                style: const TextStyle(color: Colors.white),
              ),
            ));
          }
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
                color: (_typeOrder == type) ? AppColors.primary : AppColors.silver,
                allowDrawingOutsideViewBox: true,
              ),
              Container(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: _typeOrder == type ? gilroyBold : gilroyMedium,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildAddressSection(int provDil, BuildContext context) {
    return Visibility(
      visible: _typeOrder == 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationDropdown(provDil),
          const SizedBox(height: 25),
          Text(
            constants.ru_address[provDil],
            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
          ),
          Provider.of<Favourite>(context).address.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 60,
                  ),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  primary: false,
                  itemCount: Provider.of<Favourite>(context).address.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _whichAddress = index;
                          _sendAddress.text = Provider.of<Favourite>(context, listen: false).address[index].address_txt;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/language_selected.svg',
                              color: (_whichAddress == index) ? AppColors.primary : AppColors.silver,
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
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 40),
            height: 150,
            child: TextField(
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.top,
              expands: true,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: _sendAddress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
                labelText: constants.ru_adres[provDil],
                labelStyle: const TextStyle(fontSize: 16, fontFamily: 'Semi', color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteField(int provDil) {
    return Visibility(
      visible: true,
      child: TextField(
        controller: _sendNote,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 25, top: 20, bottom: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.25))),
          labelText: constants.ru_note[provDil],
          labelStyle: const TextStyle(fontSize: 16, fontFamily: gilroyMedium, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context, int provDil) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      decoration: BoxDecoration(color: AppColors.light_silver, borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: AppColors.light_silver)),
      child: Column(
        children: [
          _buildPriceRow(constants.ru_product_price[provDil], '${Provider.of<ProvItem>(context).price.toStringAsFixed(2)} TMT'),
          if (_typeOrder == 2) const SizedBox(height: 25),
          if (_typeOrder == 2)
            _buildPriceRow(
              constants.ru_extra_info[provDil],
              _selectedLocation == '' ? '0  TMT' : '${_selectedLocation?.shipping_fee} TMT',
              // (Provider.of<ProvItem>(context).price > Provider.of<Which_page>(context).dostawka_min) ? '0  TMT' : '${Provider.of<Which_page>(context).dostawka_price.toStringAsFixed(2)} TMT',
            ),
          const SizedBox(height: 25),
          _buildPriceRow(
            constants.ru_discount_info[provDil],
            '${Provider.of<ProvItem>(context).dis.toStringAsFixed(2)}TMT',
          ),
          if (_selectBonus)
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    constants.ru_bonus[provDil],
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Semi',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${constants.bonusMoney} TMT',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Semi',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          _buildDivider(),
          _buildPriceRow(
            constants.ru_net_price[provDil],
            _getTotalPrice(context),
            priceTextStyle: const TextStyle(fontSize: 16, color: Colors.green, fontFamily: 'Semi'),
          ),
        ],
      ),
    );
  }

  String _getTotalPrice(BuildContext context) {
    final provItem = Provider.of<ProvItem>(context);
    final pageProvider = Provider.of<Which_page>(context);
    double totalPrice;
    double shippingFee = double.tryParse(_selectedLocation?.shipping_fee ?? '0') ?? 0; //shipping_fee null olabilir.

    if (_selectBonus) {
      totalPrice = provItem.price < pageProvider.dostawka_min ? (provItem.total_price + shippingFee - double.parse(constants.bonusMoney)) : (provItem.total_price - double.parse(constants.bonusMoney));
    } else {
      totalPrice = provItem.price < pageProvider.dostawka_min
          ? _typeOrder == 2
              ? (provItem.total_price + shippingFee)
              : provItem.total_price
          : provItem.total_price;
    }
    return "${totalPrice.toStringAsFixed(2)}TMT";
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25),
      height: 1,
      color: AppColors.silver,
    );
  }

  Widget _buildPriceRow(String label, String value, {TextStyle? priceTextStyle}) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: gilroyMedium,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: priceTextStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontFamily: gilroyBold,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, Which_page pageProvider) {
    return GestureDetector(
      onTap: () {
        if (_loader == 0) {
          setState(() {
            _loader = 1;
          });
          _sendOrder(context);
        }
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 30),
        width: Get.size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: _loader == 0
            ? Text(
                constants.ru_confirm[pageProvider.dil],
                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Semi'),
              )
            : LinearProgressIndicator(
                minHeight: 15,
                value: _animation.value,
                color: AppColors.light_silver,
                backgroundColor: AppColors.primary,
                semanticsLabel: 'Linear progress indicator',
              ),
      ),
    );
  }
}
