import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryText = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryElement = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryElement = Color.fromARGB(255, 0, 0, 0);
  static const Color secondaryBackground = Color.fromARGB(166, 209, 209, 209);
  static const Color secondaryText = Color.fromARGB(255, 150, 0, 0);
  static const Color primary = Color.fromRGBO(133, 183, 33, 1);
  static const Color orange = Color.fromRGBO(220, 158, 0, 1);
  static const Color silver = Color.fromRGBO(175, 175, 175, 1);
  static const Color green = Color.fromRGBO(13, 153, 86, 1);
  static const Color light_silver = Color.fromRGBO(238, 238, 238, 1);
  static const Color light_black = Color.fromRGBO(66, 67, 66, 1);
  static const Color logo_color = Color.fromRGBO(0, 22, 222, 1);
  static const Color appBar_back = Color.fromRGBO(255, 255, 255, 1);
  static const Color background_color = Color.fromARGB(255, 246, 246, 246);
  static const Color hover = Color.fromRGBO(133, 183, 33, 0.34);

  /// Ýokarky TabBar-daky neon ýaşyl.
  static const Color neon = Color(0xff2cf420);
}

/// Bir ýerde saklanýan neon stil - TabBar-da hem sargyt sahypasynda ulanylýar.
class NeonStyle {
  NeonStyle._();

  /// Saýlanan elementiň neon çarçuwasy we ýylpyldysy.
  static BoxDecoration selected({double radius = 12}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.neon, width: 1.5),
      boxShadow: const [
        BoxShadow(
          color: Color(0x4D2CF420), // neon %30
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  /// Ýokarky neon çyzyk (AppBar-yň aşagy üçin).
  static BoxDecoration get bottomLine {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.transparent, AppColors.neon, Colors.transparent],
      ),
      boxShadow: [
        BoxShadow(color: Color(0x662CF420), blurRadius: 6, offset: Offset(0, 1)),
      ],
    );
  }
}
//background: rgba(133, 183, 33, 1);
