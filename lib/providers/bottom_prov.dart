import 'package:flutter/material.dart';

class BottomProv with ChangeNotifier {
  // Navigator keys for each tab
  final GlobalKey<NavigatorState> yourKey1 = GlobalKey<NavigatorState>(debugLabel: 'nav_key_1');
  final GlobalKey<NavigatorState> yourKey2 = GlobalKey<NavigatorState>(debugLabel: 'nav_key_2');
  final GlobalKey<NavigatorState> yourKey3 = GlobalKey<NavigatorState>(debugLabel: 'nav_key_3');
  final GlobalKey<NavigatorState> yourKey4 = GlobalKey<NavigatorState>(debugLabel: 'nav_key_4');
  final GlobalKey<NavigatorState> yourKey5 = GlobalKey<NavigatorState>(debugLabel: 'nav_key_5');

  int _page = 0;
  int get page => _page;

  bool _ver = false;
  bool get ver => _ver;
  bool _reg = false;
  bool get reg => _reg;

  // Method to get the current NavigatorState based on the selected tab
  NavigatorState? getCurrentNavigator() {
    switch (_page) {
      case 0:
        return yourKey1.currentState;
      case 1:
        return yourKey2.currentState;
      case 2:
        return yourKey3.currentState;
      case 3:
        return yourKey4.currentState;
      case 4:
        return yourKey5.currentState;
      default:
        return null;
    }
  }

  void setPage(int index) {
    _page = index;
    notifyListeners();
  }

  void set_ver_true() {
    _ver = true;
    notifyListeners();
  }

  void set_ver_false() {
    _ver = false;
    notifyListeners();
  }

  void set_reg(bool value) {
    _reg = value;
    notifyListeners();
  }
}