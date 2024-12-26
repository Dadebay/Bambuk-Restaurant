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
// ignore: library_prefixes
import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'my_orders/main_orders.dart';

class Page5 extends StatefulWidget {
  const Page5({super.key});

  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<Which_page>(context);

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
              onPressed: () => UrlLauncher.launch("tel://+99363334994"),
              icon: const Icon(
                IconlyBold.call,
                color: AppColors.primary,
              ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 7, right: 7),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                (Provider.of<BottomProv>(context).reg)
                    ? _tile(
                        '1',
                        Constants.ru_profil[prov.dil],
                        'assets/images/login.svg',
                      )
                    : Container(),
                (Provider.of<BottomProv>(context).reg) ? Container() : _tile('2', Constants.ru_sign[prov.dil], 'assets/images/signin.svg'),

                //     _tile('3',(prov.dil!=0)?Constants.tm_address:Constants.ru_address,'assets/images/map_pin.png'),
                (Provider.of<BottomProv>(context).reg) ? Container() : _tile('3', Constants.ru_login[prov.dil], 'assets/images/login.svg'),
                _tile('4', Constants.ru_orders[prov.dil], 'assets/images/my_orders.svg'),
                // _tile('8', (prov.dil != 0) ? 'Täzelikler' : 'Новости',
                //     'assets/images/news.svg'),
                _tile('15', Constants.ru_address[prov.dil], 'assets/images/location.svg'),
                _tile('5', Constants.ru_language[prov.dil], 'assets/images/language.svg'),
                _tile('6', Constants.ru_help[prov.dil], 'assets/images/help.svg'),
                _tile('7', Constants.ru_about_us[prov.dil], 'assets/images/about_us.svg'),
                _tile('17', Constants.ru_ttt[prov.dil], 'assets/images/news.svg'),

                const SizedBox(
                  height: 80,
                ),
                (Provider.of<BottomProv>(context).reg)
                    ? GestureDetector(
                        onTap: (() {
                          DatabaseHelper.deleteUserAll();
                          setState(() {
                            Constants.phone = '';
                            Constants.token = '';
                            Constants.name = '';
                            Constants.name1 = '';
                            Constants.name2 = '';
                            Constants.email = '';
                          });
                          Provider.of<BottomProv>(context, listen: false).set_reg(false);
                          // ignore: prefer_const_constructors, use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text("Siz ulgamdan çykdyňyz!"),
                          ));
                        }),
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
                              Constants.ru_logout[prov.dil],
                              style: const TextStyle(fontFamily: 'Semi', color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _tile extends StatefulWidget {
  String id;
  String name;
  String icon;
  _tile(this.id, this.name, this.icon);

  @override
  State<_tile> createState() => __tileState();
}

class __tileState extends State<_tile> {
  void pushNav() {
    if (widget.id == "1") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const UserInf()));
    }
    if (widget.id == "2") {
      Constants.which_sign = true;
      Provider.of<BottomProv>(context, listen: false).set_ver_false();
      Navigator.pushNamed(context, '/page4');
    }
    if (widget.id == "3") {
      Constants.which_sign = false;
      Provider.of<BottomProv>(context, listen: false).set_ver_false();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Page4()));
    }
    if (widget.id == "4") {
      Provider.of<PageSettings>(context, listen: false).set_page0();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainOrders()));
    }
    if (widget.id == "15") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyAddress()));
    }

    if (widget.id == "5") {
      _dialogBuilder(context);
    }
    if (widget.id == "6") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Help()));
    }
    if (widget.id == "7") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutApp()),
      );
    }
    if (widget.id == "8") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyNews()));
    }
    if (widget.id == "17") {
      if (Provider.of<BottomProv>(context, listen: false).reg) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Comments()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Siz ulgama girdiňizmi?"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNav();
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 7,
              right: 7,
            ),
            padding: const EdgeInsets.only(left: 20, right: 10),
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
                const Icon(
                  Icons.keyboard_arrow_right,
                )
              ],
            ),
          ),
          Container(
            height: 60,
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(
              left: 7,
              right: 7,
            ),
            child: Container(
              height: 1,
              color: AppColors.light_silver,
            ),
          ),
        ],
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontFamily: 'Semi', color: AppColors.primary, fontSize: 16),
                      ),
                      child: Text(
                        Constants.ru_selectLan[Provider.of<Which_page>(context).dil],
                        style: const TextStyle(fontFamily: 'Semi', color: AppColors.primary, fontSize: 16),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
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
                            color: Provider.of<Which_page>(context).dil == 1 ? AppColors.primary : AppColors.silver,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'Türkmen dili',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Provider.of<Which_page>(context, listen: false).setTm();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
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
                            color: Provider.of<Which_page>(context).dil == 0 ? AppColors.primary : AppColors.silver,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'Русский',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Provider.of<Which_page>(context, listen: false).setRu();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
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
                            color: Provider.of<Which_page>(context).dil == 2 ? AppColors.primary : AppColors.silver,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                        TextButton(
                          child: const Text(
                            'English',
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Provider.of<Which_page>(context, listen: false).setEn();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
