import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/providers/page1provider.dart';
import 'package:bamboo/values/colors.dart';
// import 'package:bamboo/values/constants.dart' as Constants;
import 'package:bamboo/values/constants.dart' as Constants;

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBar_back,
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
                    Constants.ru_programma[Provider.of<Which_page>(context).dil],
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
                          color: Colors.black,
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
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Image.asset(logoImage, width: 170, height: 170),
            const SizedBox(
              height: 50,
            ),
            Text(
              Constants.ru_version[Provider.of<Which_page>(context).dil],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
