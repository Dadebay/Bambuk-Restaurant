// ignore_for_file: non_constant_identifier_names, camel_case_types, use_build_context_synchronously

import 'dart:convert';

import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
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
  bool addMoreMoney = false;
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
    } catch (e) {}
  }

  Future<dynamic> _get(String url) async {
    try {
      final response = await http.get(Uri.https(constants.api, url));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
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
        _showOrderConfirmationSheet(context);
        _launchURL(mcat);
      } else {
        _showOrderConfirmationSheet(context);
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

  Future<void> _showOrderConfirmationSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        final dil = Provider.of<Which_page>(ctx, listen: false).dil;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
              ),
              SizedBox(width: 110, height: 110, child: Image.asset('assets/images/good_order.png')),
              const SizedBox(height: 20),
              Text(
                constants.ru_razmeshon[dil],
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.primary, fontSize: 22, fontFamily: gilroyBold),
              ),
              const SizedBox(height: 12),
              Text(
                constants.ru_potwerdit[dil],
                textAlign: TextAlign.center,
                maxLines: 4,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontFamily: gilroyMedium),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<BottomProv>(ctx, listen: false).setPage(0);
                    Navigator.pop(ctx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(constants.ru_contin[dil], style: const TextStyle(fontSize: 16, fontFamily: gilroyBold)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ─── UI constants ───
  static const _bgColor = Color(0xFFF6F7FA);
  static const _cardShadow = [BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 2))];

  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontFamily: gilroyBold, fontSize: 15, color: Colors.black)),
      ],
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : AppColors.silver, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontFamily: selected ? gilroyBold : gilroyMedium,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<Which_page>(context);
    final dil = pageProvider.dil;
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          constants.ru_send[dil],
          style: const TextStyle(fontFamily: gilroyBold, fontSize: 18, color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _buildTimeCard(context, dil),
          const SizedBox(height: 10),
          _buildOrderTypeCard(dil, context),
          const SizedBox(height: 10),
          _buildPaymentCard(dil),
          if (_ii == 1) const SizedBox(height: 10),
          if (_ii == 1) _buildBonusCard(dil),
          if (_ii == 3) const SizedBox(height: 10),
          if (_ii == 3) _buildBankCard(dil),
          if (_typeOrder == 2) const SizedBox(height: 10),
          if (_typeOrder == 2) _buildAddressCard(dil, context),
          const SizedBox(height: 10),
          _buildNoteCard(dil),
          const SizedBox(height: 16),
          _buildPriceInfo(context, dil),
          const SizedBox(height: 16),
          _buildSendButton(context, pageProvider),
        ],
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, int dil) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_timeDos[dil], IconlyLight.time_circle),
          const SizedBox(height: 12),
          GestureDetector(
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
                  final selected = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                  setState(() {
                    _timeCtl.text = DateFormat('dd.MM.yyyy kk:mm').format(selected);
                  });
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.silver),
              ),
              child: Row(
                children: [
                  const Icon(IconlyLight.calendar, color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _timeCtl.text.isEmpty ? '—' : _timeCtl.text,
                      style: TextStyle(
                        fontFamily: gilroyMedium,
                        fontSize: 14,
                        color: _timeCtl.text.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  const Icon(IconlyLight.arrow_right_2, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeCard(int dil, BuildContext context) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_dosType[dil], IconlyLight.bag_2),
          Wrap(
            children: [
              _chip(constants.ru_wynos[dil], _typeOrder == 1, () {
                setState(() {
                  _typeOrder = 1;
                  addMoreMoney = false;
                });
              }),
              _chip(constants.ru_sargamak[dil], _typeOrder == 2, () {
                setState(() {
                  _typeOrder = 2;
                  addMoreMoney = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  margin: const EdgeInsets.all(20),
                  behavior: SnackBarBehavior.floating,
                  dismissDirection: DismissDirection.down,
                  duration: const Duration(seconds: 3),
                  backgroundColor: AppColors.primary,
                  content: Text(constants.ru_textr[dil], style: const TextStyle(color: Colors.white)),
                ));
              }),
              _chip(constants.ru_bron[dil], _typeOrder == 3, () {
                setState(() {
                  _typeOrder = 3;
                  addMoreMoney = true;
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(int dil) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_type[dil], IconlyLight.wallet),
          Wrap(
            children: [
              _chip(constants.ru_cash[dil], _ii == 1, () => setState(() => _ii = 1)),
              _chip(constants.ru_kart[dil], _ii == 2, () => setState(() => _ii = 2)),
              _chip(constants.ru_online[dil], _ii == 3, () => setState(() => _ii = 3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBonusCard(int dil) {
    return _card(
      child: GestureDetector(
        onTap: () => setState(() => _selectBonus = !_selectBonus),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _selectBonus ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _selectBonus ? AppColors.primary : AppColors.silver, width: 2),
              ),
              child: _selectBonus ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                constants.ru_use_bonus[dil],
                style: const TextStyle(fontFamily: gilroyMedium, fontSize: 14, color: Colors.black),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${constants.bonusMoney} TMT',
                style: const TextStyle(fontFamily: gilroyBold, fontSize: 13, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCard(int dil) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_selectBank[dil], IconlyLight.wallet),
          Wrap(
            children: List.generate(
              _listBank.length,
              (index) => _chip(_listBank[index], _selectBank == index, () => setState(() => _selectBank = index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(int dil, BuildContext context) {
    final addresses = Provider.of<Favourite>(context).address;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_address[dil], IconlyLight.location),
          if (_locations.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.silver),
              ),
              child: DropdownButton<locations>(
                isExpanded: true,
                value: _selectedLocation,
                underline: const SizedBox(),
                icon: const Icon(IconlyLight.arrow_down_2, color: Colors.grey, size: 16),
                items: _locations.map((loc) {
                  final name = dil == 0
                      ? loc.name_ru
                      : dil == 1
                          ? loc.name_tm
                          : loc.name_en;
                  return DropdownMenuItem<locations>(
                    value: loc,
                    child: Text('$name  •  ${loc.shipping_fee} TMT', style: const TextStyle(fontFamily: gilroyMedium, fontSize: 13, color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedLocation = value),
              ),
            ),
          ],
          if (addresses.isNotEmpty) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final isSelected = _whichAddress == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _whichAddress = index;
                        _sendAddress.text = addresses[index].address_txt;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.silver, width: 1.5),
                      ),
                      child: Text(
                        addresses[index].name,
                        style: TextStyle(
                          fontFamily: isSelected ? gilroyBold : gilroyMedium,
                          fontSize: 12,
                          color: isSelected ? AppColors.primary : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 14),
          TextField(
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            maxLines: 4,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            controller: _sendAddress,
            style: const TextStyle(fontFamily: gilroyMedium, fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(14),
              hintText: constants.ru_adres[dil],
              hintStyle: const TextStyle(fontFamily: gilroyMedium, fontSize: 14, color: Colors.grey),
              filled: true,
              fillColor: _bgColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.silver),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(int dil) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_note[dil], IconlyLight.paper),
          const SizedBox(height: 12),
          TextField(
            controller: _sendNote,
            style: const TextStyle(fontFamily: gilroyMedium, fontSize: 14),
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(14),
              hintText: '...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: _bgColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.silver),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInfo(BuildContext context, int dil) {
    final provItem = Provider.of<ProvItem>(context);
    final double productPrice = double.parse(provItem.price.toStringAsFixed(2));
    final double tenPercentOfPrice = (productPrice * 10.0) / 100;
    return _card(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _priceRow(constants.ru_product_price[dil], '${provItem.price.toStringAsFixed(2)} TMT'),
          if (_typeOrder == 2) ...[
            const SizedBox(height: 16),
            _priceRow(constants.ru_extra_info[dil], '${_selectedLocation?.shipping_fee ?? 0} TMT'),
          ],
          const SizedBox(height: 16),
          _priceRow(constants.ru_discount_info[dil], '${provItem.dis.toStringAsFixed(2)} TMT', valueColor: Colors.green),
          if (addMoreMoney) ...[
            const SizedBox(height: 16),
            _priceRow(constants.service[dil], '$tenPercentOfPrice TMT'),
          ],
          if (_selectBonus) ...[
            const SizedBox(height: 16),
            _priceRow(constants.ru_bonus[dil], '${constants.bonusMoney} TMT', valueColor: Colors.orange),
          ],
          const SizedBox(height: 16),
          Container(height: 1, color: AppColors.silver),
          const SizedBox(height: 16),
          _priceRow(
            constants.ru_net_price[dil],
            _getTotalPrice(context),
            labelStyle: const TextStyle(fontSize: 15, fontFamily: gilroyBold, color: Colors.black),
            valueStyle: const TextStyle(fontSize: 17, color: AppColors.primary, fontFamily: gilroyBold),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color? valueColor, TextStyle? labelStyle, TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle ?? const TextStyle(fontSize: 14, fontFamily: gilroyMedium, color: Colors.black87)),
        Text(value, style: valueStyle ?? TextStyle(fontSize: 14, fontFamily: gilroyBold, color: valueColor ?? Colors.black)),
      ],
    );
  }

  String _getTotalPrice(BuildContext context) {
    final provItem = Provider.of<ProvItem>(context);
    final pageProvider = Provider.of<Which_page>(context);
    double totalPrice;
    double shippingFee = double.tryParse(_selectedLocation?.shipping_fee ?? '0') ?? 0;
    if (_selectBonus) {
      totalPrice = provItem.price < pageProvider.dostawka_min ? (provItem.total_price + shippingFee - double.parse(constants.bonusMoney)) : (provItem.total_price - double.parse(constants.bonusMoney));
    } else {
      totalPrice = provItem.price < pageProvider.dostawka_min
          ? _typeOrder == 2
              ? (provItem.total_price + shippingFee)
              : provItem.total_price
          : provItem.total_price;
    }
    if (addMoreMoney) {
      final double productPrice = double.parse(provItem.price.toStringAsFixed(2));
      totalPrice += (productPrice * 10.0) / 100;
    }
    return "${totalPrice.toStringAsFixed(2)} TMT";
  }

  Widget _buildSendButton(BuildContext context, Which_page pageProvider) {
    return GestureDetector(
      onTap: () {
        if (_loader == 0) {
          setState(() => _loader = 1);
          _sendOrder(context);
        }
      },
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: _loader == 0
            ? Text(
                constants.ru_confirm[pageProvider.dil],
                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: gilroyBold),
              )
            : SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  minHeight: 6,
                  value: _animation.value,
                  color: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  // borderRadius: BorderRadius.circular(3),
                ),
              ),
      ),
    );
  }
}
