import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;
  String phone="";

  void increment() {
    _count=1;
    notifyListeners();
  }
  void decrement() {
    _count=1;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
  }