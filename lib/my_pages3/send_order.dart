import 'package:bamboo/values/models.dart';
// ignore_for_file: non_constant_identifier_names, camel_case_types, use_build_context_synchronously

import 'dart:convert';

import 'package:bamboo/providers/favourite.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/values/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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

  /// Saýlanan eltip berme wagty. `null` bolsa "mümkin boldugyça çalt".
  DateTime? _pickedDateTime;

  final List<String> _listBank = ['Halk bank', 'Senagat bank', 'Rysgal bank', 'Wnesheconom bank'];
  int _loader = 0;
  int _selectBank = 0;
  int _ii = 1;
  int _typeOrder = 1;
  int _whichAddress = 0;

  /// Katlanyp bilyan bolumler: baslangycda yapyk, saylaw edilende yzyna yapylyar.
  bool _typeExpanded = false;
  bool _payExpanded = false;
  bool _bankExpanded = false;
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
          data['cart_product_ids[${prov.items[prov.myid[i]]!.id}]'] = formatQuantity(prov.items[prov.myid[i]]!.count);
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

  /// Sargyt tassyklanandan son: SendOrder sahypasyny yapyp, esasy sahypa gecyaris.
  void _goToHomePage() {
    if (!mounted) return;
    // Sebet tabynyn nawigatorynda galan SendOrder sahypasyny ayyrarys,
    // yogsam sebet tabyna dolanylanda yene sol sahypa gorunerdi.
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
    // Esasy sahypa (bottom bar indeks 0) gecyaris.
    Provider.of<BottomProv>(context, listen: false).setPage(0);
  }

  Future<void> _showOrderConfirmationSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: _sheetConstraints,
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
                  onPressed: () => Navigator.pop(ctx),
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
      // Dugmä basylsa-da, aşak süýşürilip ýapylsa-da birmeňzeş dowam edýär.
    ).then((_) => _goToHomePage());
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

  /// Yygnalyp bilyan bolum: yapyk wagty dine saylanan zat gorunyar,
  /// basylanda ahli saylawlar acylyar. Sahypa gysga bolyar we saylaw
  /// edilenden son ozi yapylyar.
  Widget _collapsibleCard({
    required IconData icon,
    required String title,
    required String valueLabel,
    required IconData valueIcon,
    required bool expanded,
    required VoidCallback onToggle,
    required List<Widget> children,
  }) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(10),
              child: Row(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title, style: const TextStyle(fontFamily: gilroyBold, fontSize: 15, color: Colors.black)),
                        // Yapyk wagty saylanan zat kicijik setirde gorunyar.
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          alignment: Alignment.topLeft,
                          child: expanded
                              ? const SizedBox(width: double.infinity)
                              : Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      Icon(valueIcon, size: 13, color: AppColors.primary),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          valueLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontFamily: gilroyMedium, fontSize: 12, color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      HugeIcons.strokeRoundedArrowDown01,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  /// Saylaw edilenden son bolumi kici gijikdirme bilen yapyarys -
  /// ulanyjy hayysy tassyklanandygyny gorup yetisyar.
  void _collapseAfterPick(void Function() setFlag) {
    Future.delayed(const Duration(milliseconds: 260), () {
      if (!mounted) return;
      setState(setFlag);
    });
  }

  /// Biri-birini aradan ayyryan saylawlar ucin doly inlilikdaki setir.
  ///
  /// Chip-lerden tapawutlylykda: basmak meydany ulurak (~64px), her saylawyn
  /// ozune mahsus ikonasy bar we uzyn terjimeler (mysal ucin "Оплата с
  /// терминала") kesilmeyar-de, ikinji setire gecyar.
  Widget _optionRow({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary.withOpacity(0.06) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.primary : const Color(0xFFE8E8E8),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Ikona gutujygy
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: selected ? Colors.white : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.black87,
                      fontFamily: selected ? gilroyBold : gilroyMedium,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Saylanandygyny gorkezyan tegelek
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.primary : const Color(0xFFD6D6D6),
                      width: 1.2,
                    ),
                  ),
                  child: selected ? const Icon(HugeIcons.strokeRoundedTick02, size: 11, color: Colors.white) : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────── Ölçege görä ýerleşdiriş ───────────────

  /// Aşaky penjireler planşetde tutuş ekrana ýaýrap gitmez ýaly çäklendirilýär.
  static const BoxConstraints _sheetConstraints = BoxConstraints(maxWidth: 560);

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<Which_page>(context);
    final dil = pageProvider.dil;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          constants.ru_send[dil],
          style: const TextStyle(fontFamily: gilroyBold, fontSize: 18, color: Colors.black),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, box) {
          final double width = box.maxWidth;
          // Iki sütün: planşetiň keseligine görnüşi ýaly giň ekranlarda
          // saýlawlar çepde, hasap bilen tassyklama düwmesi sagda durýar.
          final bool twoColumns = width >= 900;
          final double pad = width >= 600 ? 24 : 16;

          // Çep sütün: sargyt barada saýlawlar
          final List<Widget> choices = [
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
          ];

          // Sag sütün: bellik, hasap we tassyklama
          final List<Widget> summary = [
            _buildNoteCard(dil),
            const SizedBox(height: 16),
            _buildPriceInfo(context, dil),
            const SizedBox(height: 16),
            _buildSendButton(context, pageProvider),
          ];

          if (twoColumns) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(pad, pad, pad, 100),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: choices),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: summary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          // Dar we orta ekranlar: bir sütün, ýöne planşetde kartlar
          // tutuş ekrana çekilmän, ortada çäklendirilen inlilikde durýar.
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: EdgeInsets.fromLTRB(pad, pad, pad, 100),
                children: [
                  ...choices,
                  const SizedBox(height: 10),
                  ...summary,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────── Wagt saýlaýjy ───────────────

  /// Ýeke bir aşaky penjirede gün + sagat saýlanýar.
  /// Öňki görnüşde Material-yň iki sany standart dialogy yzly-yzyna açylýardy.
  Future<void> _openTimeSheet(BuildContext context, int dil) async {
    final DateTime now = DateTime.now();

    // Öň saýlanan bolsa şondan başlaýarys.
    DateTime selectedDay = _pickedDateTime ?? now;
    DateTime selectedTime = _pickedDateTime ?? now.add(const Duration(minutes: 30));
    bool asap = _pickedDateTime == null;

    // Indiki 14 gün
    final List<DateTime> days = List.generate(
      14,
      (i) => DateTime(now.year, now.month, now.day).add(Duration(days: i)),
    );

    final DateTime? result = await showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: _sheetConstraints,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom + 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tutawaç
                  Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(top: 10, bottom: 14),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
                  ),
                  // Baş setir
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(HugeIcons.strokeRoundedClock01, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            constants.ru_pick_time[dil],
                            style: const TextStyle(fontFamily: gilroyBold, fontSize: 17, color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(9)),
                            child: const Icon(HugeIcons.strokeRoundedCancel01, size: 15, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // "Mümkin boldugyça çalt" - iň köp ulanylýan ýagdaý
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _sheetAsapRow(
                      label: constants.ru_asap[dil],
                      selected: asap,
                      onTap: () => setSheet(() => asap = true),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: Container(height: 1, color: const Color(0xFFEFEFEF))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            constants.ru_pick_time[dil],
                            style: TextStyle(fontFamily: gilroyMedium, fontSize: 11, color: Colors.grey.shade400),
                          ),
                        ),
                        Expanded(child: Container(height: 1, color: const Color(0xFFEFEFEF))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Gün saýlaýjy - keseligine süýşýän
                  SizedBox(
                    height: 66,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: days.length,
                      itemBuilder: (_, i) {
                        final day = days[i];
                        final bool isSelected = !asap &&
                            day.year == selectedDay.year &&
                            day.month == selectedDay.month &&
                            day.day == selectedDay.day;
                        String top;
                        if (i == 0) {
                          top = constants.ru_today[dil];
                        } else if (i == 1) {
                          top = constants.ru_tomorrow[dil];
                        } else {
                          top = constants.weekdayShort[dil][day.weekday - 1];
                        }
                        return GestureDetector(
                          onTap: () => setSheet(() {
                            selectedDay = day;
                            asap = false;
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 62,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : const Color(0xFFF6F7FA),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : const Color(0xFFEDEDED),
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  top,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: gilroyMedium,
                                    fontSize: 10,
                                    color: isSelected ? Colors.white70 : Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  day.day.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontFamily: gilroyBold,
                                    fontSize: 18,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Sagat çarhy - Material-yň dialogyndan has çalt we rahat
                  SizedBox(
                    height: 150,
                    child: Opacity(
                      opacity: asap ? 0.35 : 1,
                      child: IgnorePointer(
                        ignoring: asap,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          minuteInterval: 5,
                          initialDateTime: DateTime(
                            now.year,
                            now.month,
                            now.day,
                            selectedTime.hour,
                            selectedTime.minute - (selectedTime.minute % 5),
                          ),
                          onDateTimeChanged: (value) => selectedTime = value,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tassykla
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (asap) {
                            Navigator.pop(ctx, null);
                          } else {
                            Navigator.pop(
                              ctx,
                              DateTime(
                                selectedDay.year,
                                selectedDay.month,
                                selectedDay.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          constants.ru_otp_confirm[dil],
                          style: const TextStyle(fontSize: 15, fontFamily: gilroyBold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (!mounted) return;
    setState(() {
      _pickedDateTime = result;
      _timeCtl.text = result == null ? '' : DateFormat('dd.MM.yyyy kk:mm').format(result);
    });
  }

  /// "Mümkin boldugyça çalt" setiri.
  Widget _sheetAsapRow({required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE8E8E8), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : const Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                HugeIcons.strokeRoundedFlash,
                size: 16,
                color: selected ? Colors.white : Colors.grey.shade500,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: selected ? gilroyBold : gilroyMedium,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(color: selected ? AppColors.primary : const Color(0xFFD6D6D6), width: 1.2),
              ),
              child: selected ? const Icon(HugeIcons.strokeRoundedTick02, size: 11, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  /// "Mümkin boldugyça çalt" saýlanan ýagdaýda çak edilýän eltip berme sagady:
  /// häzirki wagt + 30 minut taýýarlyk.
  String _asapEstimate() {
    return DateFormat('HH:mm').format(DateTime.now().add(const Duration(minutes: 30)));
  }

  Widget _buildTimeCard(BuildContext context, int dil) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_timeDos[dil], HugeIcons.strokeRoundedClock01),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _openTimeSheet(context, dil);
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
                  Icon(
                    _pickedDateTime == null ? HugeIcons.strokeRoundedFlash : HugeIcons.strokeRoundedCalendar01,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // Wagt saýlanmadyk bolsa "mümkin boldugyça çalt" hem doly hukukly
                    // saýlaw - şonuň üçin boş "—" däl-de, şol ýazgy görkezilýär.
                    // Ýanynda çak edilýän eltip berme sagady hem görkezilýär,
                    // ýogsam bu ýagdaýda hiç hili wagt görnenokdy.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _pickedDateTime == null ? constants.ru_asap[dil] : _timeCtl.text,
                          style: const TextStyle(
                            fontFamily: gilroyMedium,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        if (_pickedDateTime == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '≈ ${_asapEstimate()}',
                              style: TextStyle(
                                fontFamily: gilroyMedium,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(HugeIcons.strokeRoundedArrowRight01, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────── Sargydyn görnüşi ───────────────

  IconData _orderTypeIcon(int type) {
    if (type == 1) return HugeIcons.strokeRoundedShoppingBag02;
    if (type == 2) return HugeIcons.strokeRoundedScooter01;
    return HugeIcons.strokeRoundedRestaurantTable;
  }

  String _orderTypeLabel(int dil, int type) {
    if (type == 1) return constants.ru_wynos[dil];
    if (type == 2) return constants.ru_sargamak[dil];
    return constants.ru_bron[dil];
  }

  IconData _payIcon(int type) {
    if (type == 1) return HugeIcons.strokeRoundedMoney01;
    if (type == 2) return HugeIcons.strokeRoundedCreditCard;
    return HugeIcons.strokeRoundedGlobal;
  }

  String _payLabel(int dil, int type) {
    if (type == 1) return constants.ru_cash[dil].trim();
    if (type == 2) return constants.ru_kart[dil];
    return constants.ru_online[dil];
  }

  void _pickOrderType(int type, BuildContext context, int dil) {
    setState(() {
      _typeOrder = type;
      addMoreMoney = type == 3;
    });
    if (type == 2) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.primary,
        content: Text(constants.ru_textr[dil], style: const TextStyle(color: Colors.white)),
      ));
    }
    _collapseAfterPick(() => _typeExpanded = false);
  }

  Widget _buildOrderTypeCard(int dil, BuildContext context) {
    return _collapsibleCard(
      icon: HugeIcons.strokeRoundedShoppingBag02,
      title: constants.ru_dosType[dil],
      valueLabel: _orderTypeLabel(dil, _typeOrder),
      valueIcon: _orderTypeIcon(_typeOrder),
      expanded: _typeExpanded,
      onToggle: () => setState(() => _typeExpanded = !_typeExpanded),
      children: [
        for (final type in [1, 2, 3])
          _optionRow(
            icon: _orderTypeIcon(type),
            label: _orderTypeLabel(dil, type),
            selected: _typeOrder == type,
            onTap: () => _pickOrderType(type, context, dil),
          ),
      ],
    );
  }

  Widget _buildPaymentCard(int dil) {
    return _collapsibleCard(
      icon: HugeIcons.strokeRoundedWallet01,
      title: constants.ru_type[dil],
      valueLabel: _payLabel(dil, _ii),
      valueIcon: _payIcon(_ii),
      expanded: _payExpanded,
      onToggle: () => setState(() => _payExpanded = !_payExpanded),
      children: [
        for (final type in [1, 2, 3])
          _optionRow(
            icon: _payIcon(type),
            label: _payLabel(dil, type),
            selected: _ii == type,
            onTap: () {
              setState(() => _ii = type);
              _collapseAfterPick(() => _payExpanded = false);
            },
          ),
      ],
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
    return _collapsibleCard(
      icon: HugeIcons.strokeRoundedBank,
      title: constants.ru_selectBank[dil],
      valueLabel: _listBank[_selectBank],
      valueIcon: HugeIcons.strokeRoundedBank,
      expanded: _bankExpanded,
      onToggle: () => setState(() => _bankExpanded = !_bankExpanded),
      children: [
        ...List.generate(
          _listBank.length,
          (index) => _optionRow(
            icon: HugeIcons.strokeRoundedBank,
            label: _listBank[index],
            selected: _selectBank == index,
            onTap: () {
              setState(() => _selectBank = index);
              _collapseAfterPick(() => _bankExpanded = false);
            },
          ),
        ),
      ],
    );
  }

  // ─────────────── Salgy ───────────────

  String _locName(locations loc, int dil) {
    if (dil == 0) return loc.name_ru;
    if (dil == 1) return loc.name_tm;
    return loc.name_en;
  }

  /// Sebit saýlaýjy: DropdownButton ýerine aşaky penjire - her sebitiň
  /// eltip berme tölegi we iň az sargyt möçberi bilelikde görünýär.
  Future<void> _openRegionSheet(BuildContext context, int dil) async {
    final locations? picked = await showModalBottomSheet<locations>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: _sheetConstraints,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom + 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 14),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(HugeIcons.strokeRoundedLocation01, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        constants.ru_pick_region[dil],
                        style: const TextStyle(fontFamily: gilroyBold, fontSize: 17, color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(9)),
                        child: const Icon(HugeIcons.strokeRoundedCancel01, size: 15, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  itemCount: _locations.length,
                  itemBuilder: (_, i) {
                    final loc = _locations[i];
                    final bool isSelected = _selectedLocation?.id == loc.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(ctx, loc),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : const Color(0xFFE8E8E8),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : const Color(0xFFF4F4F4),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Icon(
                                  HugeIcons.strokeRoundedLocation01,
                                  size: 16,
                                  color: isSelected ? Colors.white : Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _locName(loc, dil),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: isSelected ? gilroyBold : gilroyMedium,
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${constants.ru_min_order[dil]}: ${loc.min_order_fee} TMT',
                                      style: TextStyle(fontFamily: gilroyMedium, fontSize: 11, color: Colors.grey.shade500),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              _feePill(loc.shipping_fee, isSelected),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || picked == null) return;
    setState(() => _selectedLocation = picked);
  }

  /// Eltip berme tölegini görkezýän kiçijik nyşan.
  Widget _feePill(String fee, bool highlighted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primary : const Color(0xFFF2F3F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$fee TMT',
        style: TextStyle(
          fontFamily: gilroyBold,
          fontSize: 11,
          color: highlighted ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildAddressCard(int dil, BuildContext context) {
    final addresses = Provider.of<Favourite>(context).address;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(constants.ru_address[dil], HugeIcons.strokeRoundedLocation01),

          // Sebit - basylanda aşaky penjire açylýar
          if (_locations.isNotEmpty) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _openRegionSheet(context, dil);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.silver),
                ),
                child: Row(
                  children: [
                    const Icon(HugeIcons.strokeRoundedMapsLocation01, color: AppColors.primary, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            constants.ru_region[dil],
                            style: TextStyle(fontFamily: gilroyMedium, fontSize: 11, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _selectedLocation == null ? constants.ru_pick_region[dil] : _locName(_selectedLocation!, dil),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontFamily: gilroyBold, fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_selectedLocation != null) _feePill(_selectedLocation!.shipping_fee, false),
                    const SizedBox(width: 6),
                    const Icon(HugeIcons.strokeRoundedArrowRight01, color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ),
          ],

          // Ýatda saklanan salgylar - ady bilen bilelikde salgynyň özi hem
          // görünýär, şonuň üçin haýsydygy çaklamaly bolanok.
          if (addresses.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              constants.ru_saved_address[dil],
              style: TextStyle(fontFamily: gilroyMedium, fontSize: 11, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 64,
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
                      width: 190,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFE8E8E8), width: 1.2),
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : const Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              HugeIcons.strokeRoundedHome01,
                              size: 15,
                              color: isSelected ? Colors.white : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addresses[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: isSelected ? gilroyBold : gilroyMedium,
                                    fontSize: 12.5,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  addresses[index].address_txt,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontFamily: gilroyMedium, fontSize: 10.5, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 4),
                            Container(
                              width: 17,
                              height: 17,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                              child: const Icon(HugeIcons.strokeRoundedTick02, size: 10, color: Colors.white),
                            ),
                          ],
                        ],
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
          _sectionLabel(constants.ru_note[dil], HugeIcons.strokeRoundedNote01),
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
