import 'package:flutter/material.dart';

class BottomProv with ChangeNotifier {
  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;
  GlobalKey<NavigatorState> yourKey1 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> yourKey2 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> yourKey3 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> yourKey4 = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> yourKey5 = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> _yourKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get yourKey => _yourKey;

  int _page = 0;
  int get page => _page;

  bool _ver = false;
  bool get ver => _ver;
  bool _reg = false;
  bool get reg => _reg;

  void set_page0() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeIn,
    );
    _page = 0;
    _yourKey = yourKey1;
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
  //64655643


  void setPage1() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeIn,
    );
    _page = 1;
    _yourKey = yourKey2;
    notifyListeners();
  }

  void setPage2() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeIn,
    );
    _page = 2;
    _yourKey = yourKey3;
    notifyListeners();
  }

  void setPage3() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeIn,
    );
    _page = 3;
    _yourKey = yourKey4;
    notifyListeners();
  }

  void setPage4() {
    _pageController.animateToPage(
      4,
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeIn,
    );
    _page = 4;
    _yourKey = yourKey5;
    notifyListeners();
  }
}
