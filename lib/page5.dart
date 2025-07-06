import 'package:bamboo/DB/db.dart';
import 'package:bamboo/my_pages5/about_app.dart';
import 'package:bamboo/my_pages5/comments.dart';
import 'package:bamboo/my_pages5/help.dart';
import 'package:bamboo/my_pages5/my_address.dart';
import 'package:bamboo/my_pages5/my_news.dart';
import 'package:bamboo/my_pages5/user_info.dart';
import 'package:bamboo/page4.dart';
import 'package:bamboo/providers/bottom_prov.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/providers/page1settings.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'my_orders/main_orders.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<Which_page>(context);
    final bottomProv = Provider.of<BottomProv>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              if (bottomProv.reg)
                _buildTile(
                  '1',
                  constants.ru_profil[pageProvider.dil],
                  'assets/images/login.svg',
                ),
              if (!bottomProv.reg)
                _buildTile(
                  '2',
                  constants.ru_sign[pageProvider.dil],
                  'assets/images/signin.svg',
                ),
              if (!bottomProv.reg)
                _buildTile(
                  '3',
                  constants.ru_login[pageProvider.dil],
                  'assets/images/login.svg',
                ),
              _buildTile('4', constants.ru_orders[pageProvider.dil], 'assets/images/my_orders.svg'),
              _buildTile('15', constants.ru_address[pageProvider.dil], 'assets/images/location.svg'),
              _buildTile('5', constants.ru_language[pageProvider.dil], 'assets/images/language.svg'),
              _buildTile('6', constants.ru_help[pageProvider.dil], 'assets/images/help.svg'),
              _buildTile('7', constants.ru_about_us[pageProvider.dil], 'assets/images/about_us.svg'),
              _buildTile('17', constants.ru_ttt[pageProvider.dil], 'assets/images/news.svg'),
              const SizedBox(height: 80),
              if (bottomProv.reg) _buildLogoutButton(context, pageProvider, bottomProv),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String id, String name, String icon) {
    return _Tile(id: id, name: name, icon: icon);
  }

  Widget _buildLogoutButton(BuildContext context, Which_page pageProvider, BottomProv bottomProv) {
    return GestureDetector(
      onTap: () {
        _logout(context, bottomProv);
      },
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 60,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            constants.ru_logout[pageProvider.dil],
            style: const TextStyle(fontFamily: 'Semi', color: Colors.white),
          ),
        ),
      ),
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
  final String icon;

  const _Tile({super.key, required this.id, required this.name, required this.icon});

  @override
  __TileState createState() => __TileState();
}

class __TileState extends State<_Tile> {
  void _pushNav(BuildContext context) {
    switch (widget.id) {
      case "1":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInf()));
        break;
      case "2":
        constants.which_sign = true;
        Provider.of<BottomProv>(context, listen: false).set_ver_false();
        Navigator.pushNamed(context, '/page4');
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
      case "6":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Help()));
        break;
      case "7":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutApp()));
        break;
      case "8":
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyNews()));
        break;
      case "17":
        _navigateToComments(context);
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
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 7),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: SvgPicture.asset(
                    widget.icon,
                    height: 20,
                    width: 20,
                    color: AppColors.primary,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.name,
                    style: const TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Semi'),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          Container(
            height: 60,
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.symmetric(horizontal: 7),
            child: Container(
              height: 1,
              color: AppColors.light_silver,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const _LanguageDialog();
      },
    );
  }
}

class _LanguageDialog extends StatelessWidget {
  const _LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<Which_page>(context);

    return AlertDialog(
      actions: <Widget>[
        SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  constants.ru_selectLan[pageProvider.dil],
                  style: const TextStyle(fontFamily: 'Semi', color: AppColors.primary, fontSize: 16),
                ),
              ),
              _buildLanguageButton(context, 'Türkmen dili', 1, pageProvider),
              const SizedBox(height: 15),
              _buildLanguageButton(context, 'Русский', 0, pageProvider),
              const SizedBox(height: 15),
              _buildLanguageButton(context, 'English', 2, pageProvider),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageButton(BuildContext context, String languageName, int languageCode, Which_page pageProvider) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white),
            child: SvgPicture.asset(
              'assets/images/language_selected.svg',
              color: pageProvider.dil == languageCode ? AppColors.primary : AppColors.silver,
              allowDrawingOutsideViewBox: true,
            ),
          ),
          TextButton(
            child: Text(
              languageName,
              style: const TextStyle(color: Colors.black),
            ),
            onPressed: () {
              _setLanguage(context, languageCode);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _setLanguage(BuildContext context, int languageCode) {
    final whichPageProvider = Provider.of<Which_page>(context, listen: false);
    switch (languageCode) {
      case 0:
        whichPageProvider.setRu();
        break;
      case 1:
        whichPageProvider.setTm();
        break;
      case 2:
        whichPageProvider.setEn();
        break;
    }
  }
}
