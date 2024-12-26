import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:bamboo/DB/db.dart';
import 'package:bamboo/values/models.dart';

class Favourite with ChangeNotifier, DiagnosticableTreeMixin {
  List _myid = [];
  List get myid => _myid;

  String phone = "";
  Map<int, products> _items = {};

  List<model_address> _address = [];
  List<model_address> get address => _address;

  Map<int, products> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addAddress(String name, String address_txt) {
    _address.add(model_address(name: name, address_txt: address_txt));
    notifyListeners();
  }

  void addSplash(
      int id,
      String name_tm,
      String name_ru,
      String name_en,
      var description_tm,
      var description_ru,
      var description_en,
      String image,
      double price,
      int count,
      double rating,
      int discount,
      double discount_price,
      String category,
      var values) {
    if (_items.containsKey(id)) {
    } else {
      _myid.add(id);
      _items.putIfAbsent(
        id,
        () => products(
            id: id,
            name_tm: name_tm,
            name_ru: name_ru,
            name_en: name_en,
            description_tm: description_tm,
            description_ru: description_ru,
            description_en: description_en,
            image: image,
            price: price,
            count: count,
            rating: rating,
            discount: discount,
            discount_price: discount_price,
            category: category,
            values: values),
      );
      notifyListeners();
    }
  }

  void addItem(
      int id,
      String name_tm,
      String name_ru,
      String name_en,
      var description_tm,
      var description_ru,
      var description_en,
      String image,
      double price,
      int count,
      double rating,
      int discount,
      double discount_price,
      String category,
      var values) {
    _myid.add(id);
    DatabaseHelper.createFavor(
        id,
        name_tm,
        name_ru,
        name_en,
        description_tm,
        description_ru,
        description_en,
        image,
        price,
        count,
        rating,
        discount,
        discount_price,
        category);
    _items.putIfAbsent(
      id,
      () => products(
          id: id,
          name_tm: name_tm,
          name_ru: name_ru,
          name_en: name_en,
          description_tm: description_tm,
          description_ru: description_ru,
          description_en: description_en,
          image: image,
          price: price,
          count: count,
          rating: rating,
          discount: discount,
          discount_price: discount_price,
          category: category,
          values: values),
    );
    notifyListeners();
  }

  void removeItem(int id) {
    _myid.remove(id);
    DatabaseHelper.deleteFavor(id);
    _items.remove(id);

    notifyListeners();
  }
}
