import 'package:bamboo/DB/db.dart';
import 'package:bamboo/my_pages5/comments.dart';
import 'package:bamboo/my_pages5/chat_page.dart';
import 'package:bamboo/my_pages5/my_address.dart';
import 'package:bamboo/my_pages5/my_news.dart';
import 'package:bamboo/my_pages5/user_info.dart';
import 'package:bamboo/page4.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/page1settings.dart';
import 'package:bamboo/user_reviews_page/notifications_page.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/values/models.dart';
import 'package:bamboo/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'dart:convert';

import 'my_orders/main_orders.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  List<help> _helpContent = [];
  bool _isLoadingHelp = false;

  @override
  void initState() {
    super.initState();
    _loadHelpContent();
  }

  Future<void> _loadHelpContent() async {
    setState(() {
      _isLoadingHelp = true;
    });

    try {
      final response = await http.get(Uri.https(constants.api, '/api/v1/pages'));
      final data = json.decode(utf8.decode(response.bodyBytes))['data'] as List<dynamic>;
      final items = <help>[];

      for (final item in data) {
        items.add(help(
          id: item['id'],
          name_tm: item['name_tm'] ?? '',
          name_ru: item['name_ru'] ?? '',
          name_en: item['name_en'] ?? '',
          body_tm: item['pages'] == null ? '' : item['pages'][0]['body_tm'] ?? '',
          body_ru: item['pages'] == null ? '' : item['pages'][0]['body_ru'] ?? '',
          body_en: item['pages'] == null ? '' : item['pages'][0]['body_en'] ?? '',
        ));
      }

      if (!mounted) return;
      setState(() {
        _helpContent = items.take(2).toList();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _helpContent = [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingHelp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<Which_page>(context);
    final bottomProv = Provider.of<BottomProv>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        leading: const SizedBox.shrink(),
        title: logo(),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => url_launcher.launchUrl(Uri.parse("tel://+99363334994")),
            icon: const Icon(
              IconlyBold.call,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: _buildBody(context, pageProvider, bottomProv),
    );
  }

  Widget _buildBody(BuildContext context, Which_page pageProvider, BottomProv bottomProv) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      children: [
        if (bottomProv.reg) _buildTile('1', constants.ru_profil[pageProvider.dil], HugeIcons.strokeRoundedLogin03),
        if (!bottomProv.reg) _buildTile('2', constants.ru_sign[pageProvider.dil], HugeIcons.strokeRoundedLogin02),
        if (!bottomProv.reg) _buildTile('3', constants.ru_login[pageProvider.dil], HugeIcons.strokeRoundedLogin01),
        _buildTile('4', constants.ru_orders[pageProvider.dil], HugeIcons.strokeRoundedShoppingBag01),
        _buildTile('15', constants.ru_address[pageProvider.dil], IconlyLight.location),
        _buildTile('5', constants.ru_language[pageProvider.dil], HugeIcons.strokeRoundedLanguageCircle),
        _buildHelpSection(pageProvider),
        if (bottomProv.reg) _buildTile('19', constants.ru_ttt[pageProvider.dil], IconlyLight.chat),

        // _buildTile('17', constants.ru_ttt[pageProvider.dil], IconlyLight.document),
        _buildTile('18', constants.ru_notifications[pageProvider.dil], IconlyLight.notification),
        if (bottomProv.reg) _buildLogoutTile(context, pageProvider, bottomProv),
        _buildAboutSection(pageProvider),
      ],
    );
  }

  Widget _buildLogoutTile(BuildContext context, Which_page pageProvider, BottomProv bottomProv) {
    return GestureDetector(
      onTap: () => _logout(context, bottomProv),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: const Icon(IconlyLight.logout, color: Colors.red, size: 24),
            ),
            Expanded(
              child: Text(
                constants.ru_logout[pageProvider.dil],
                style: const TextStyle(color: Colors.red, fontSize: 15, fontFamily: 'Semi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String id, String name, dynamic icon) {
    return _Tile(id: id, name: name, icon: icon);
  }

  Widget _buildAboutSection(Which_page pageProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Image.asset(constants.logoImage, width: 48, height: 48),
          const SizedBox(height: 6),
          Text(
            'Bamboo Restaurant',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontFamily: 'Semi', letterSpacing: 0.3),
          ),
          const SizedBox(height: 2),
          Text(
            constants.ru_version[pageProvider.dil],
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(Which_page pageProvider) {
    if (_isLoadingHelp) {
      return Container(
        height: 56,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    }

    if (_helpContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: _helpContent
          .map((item) => _ProfileHelpTile(
                item: item,
                languageCode: pageProvider.dil,
              ))
          .toList(),
    );
  }

  void _logout(BuildContext context, BottomProv bottomProv) {
    DatabaseHelper.deleteUserAll();
    setState(() {
      constants.phone = '';
      constants.token = '';
      constants.name = '';
      constants.name1 = '';
      constants.name2 = '';
      constants.email = '';
    });
    bottomProv.set_reg(false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Siz ulgamdan çykdyňyz!"),
      ),
    );
  }
}

class _Tile extends StatefulWidget {
  final String id;
  final String name;
  final dynamic icon;

  const _Tile({required this.id, required this.name, required this.icon});

  @override
  __TileState createState() => __TileState();
}

class __TileState extends State<_Tile> {
  void _pushNav(BuildContext context) {
    switch (widget.id) {
      case "1":
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserInf()));
        break;
      case "2":
        constants.which_sign = true;
        Provider.of<BottomProv>(context, listen: false).set_ver_false();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Page4()));
        break;
      case "3":
        constants.which_sign = false;
        Provider.of<BottomProv>(context, listen: false).set_ver_false();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Page4()));
        break;
      case "4":
        Provider.of<PageSettings>(context, listen: false).set_page0();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MainOrders()));
        break;
      case "15":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAddress()));
        break;
      case "5":
        _showLanguageDialog(context);
        break;
      case "8":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyNews()));
        break;
      case "17":
        _navigateToComments(context);
        break;
      case "18":
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
        break;
      case "19":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
        break;
    }
  }

  void _navigateToComments(BuildContext context) {
    final bottomProv = Provider.of<BottomProv>(context, listen: false);
    if (bottomProv.reg) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Comments()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Siz ulgama girdiňizmi?"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pushNav(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        margin: EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: widget.icon is String
                  ? SvgPicture.asset(
                      widget.icon,
                      height: 20,
                      width: 20,
                      color: AppColors.primary,
                      allowDrawingOutsideViewBox: true,
                    )
                  : Icon(
                      widget.icon as IconData,
                      color: AppColors.primary,
                      size: 24,
                    ),
            ),
            Expanded(
              child: Text(
                widget.name,
                style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Semi'),
              ),
            ),
            Icon(IconlyLight.arrow_right_circle, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<Which_page>(
                builder: (_, prov, __) => Column(
                  children: [
                    Text(
                      constants.ru_selectLan[prov.dil],
                      style: const TextStyle(fontFamily: 'Semi', fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    _buildLangOption(ctx, prov, 'Türkmen dili', '🇹🇲', 1),
                    const SizedBox(height: 10),
                    _buildLangOption(ctx, prov, 'Русский', '🇷🇺', 0),
                    const SizedBox(height: 10),
                    _buildLangOption(ctx, prov, 'English', '🇬🇧', 2),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLangOption(BuildContext context, Which_page prov, String label, String flag, int code) {
    final isSelected = prov.dil == code;
    return GestureDetector(
      onTap: () {
        if (code == 0)
          prov.setRu();
        else if (code == 1)
          prov.setTm();
        else
          prov.setEn();
        Navigator.of(context).pop();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : const Color(0xFFF6F7FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: isSelected ? 'Semi' : 'GilroyRegular',
                  fontSize: 15,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
            ),
            if (isSelected) const Icon(IconlyBold.tick_square, color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ProfileHelpTile extends StatefulWidget {
  final help item;
  final int languageCode;

  const _ProfileHelpTile({required this.item, required this.languageCode});

  @override
  State<_ProfileHelpTile> createState() => _ProfileHelpTileState();
}

class _ProfileHelpTileState extends State<_ProfileHelpTile> {
  bool _expanded = false;

  String _sanitize(String html) {
    var value = html;
    value = value.replaceAll('<h2 style="text-align: center;">', '');
    value = value.replaceAll('<h2', '<p');
    value = value.replaceAll('<h1', '<p');
    value = value.replaceAll('<h3', '<p');
    value = value.replaceAll('<h4', '<p');
    value = value.replaceAll('<h5', '<p');
    value = value.replaceAll('<strong>', '');
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.languageCode == 1
        ? widget.item.name_tm
        : widget.languageCode == 0
            ? widget.item.name_ru
            : widget.item.name_en;
    final body = widget.languageCode == 1
        ? _sanitize(widget.item.body_tm)
        : widget.languageCode == 0
            ? _sanitize(widget.item.body_ru)
            : _sanitize(widget.item.body_en);

    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 12),
                  child: Icon(
                    IconlyLight.info_circle,
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Semi'),
                  ),
                ),
                Icon(
                  _expanded ? IconlyLight.arrow_down_circle : IconlyLight.arrow_right_circle,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Html(
                data: body,
                style: {
                  'body': Style(fontFamily: 'GilroyRegular', fontSize: FontSize(14), color: Colors.black87),
                  'p': Style(fontFamily: 'GilroyRegular', fontSize: FontSize(14), color: Colors.black87),
                  'li': Style(fontFamily: 'GilroyRegular', fontSize: FontSize(14), color: Colors.black87),
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
