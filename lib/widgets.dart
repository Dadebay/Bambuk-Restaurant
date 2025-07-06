import 'package:bamboo/values/constants.dart';
import 'package:flutter/cupertino.dart';

dynamic logo() {
  return Center(
    child: Image.asset(
      logoImage,
      fit: BoxFit.contain,
      width: 70,
      alignment: Alignment.center,
      height: 60,
    ),
  );
}
