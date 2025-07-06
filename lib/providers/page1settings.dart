import 'package:flutter/material.dart';

class PageSettings with ChangeNotifier {

  final PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;
   int _page = 0; 
   int get page => _page;

  void set_page0() {
    _page=0;
    notifyListeners();
  }
  void set_page1() {
    _page=1;
    notifyListeners();
  }
  
}
