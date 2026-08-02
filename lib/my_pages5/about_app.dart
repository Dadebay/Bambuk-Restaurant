import 'package:bamboo/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:bamboo/providers/page1provider.dart';
// import 'package:bamboo/values/colors.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(IconlyLight.arrow_left, color: Colors.black),
        ),
        title: Text(
          Constants.ru_programma[Provider.of<Which_page>(context).dil],
          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Semi'),
        ),
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
