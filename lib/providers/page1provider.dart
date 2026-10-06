import 'package:flutter/foundation.dart';
import 'package:bamboo/DB/db.dart';

import 'package:bamboo/values/models.dart';

class Which_page with ChangeNotifier, DiagnosticableTreeMixin {
  int _page = 1;
  int get page => _page;

  int _page_log = 0;
  int get page_log => _page_log;

  int _page_log2 = 0;
  int get page_log2 => _page_log2;

  double _dostawka_price = 0.00;
  double get dostawka_price => _dostawka_price;

  double _dostawka_min = 0.00;
  double get dostawka_min => _dostawka_min;

  int _page_cart = 1;
  int get page_cart => _page_cart;

  int _dil = 1;
  int get dil => _dil;

  double _total_price = 0.00;
  double get total_price => _total_price;

  double _price = 0.00;
  double get price => _price;

  double _dis = 0.00;
  double get dis => _dis;

  final List _myid = [];
  List get myid => _myid;

  String phone = "";
  final Map<int, products> _items = {};

  Map<int, products> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void setDosPrice(double pp) {
    _dostawka_price = pp;
    notifyListeners();
  }

  void setDosMin(double pp) {
    _dostawka_min = pp;
    notifyListeners();
  }

  void addSplash(int id, String nameTm, String nameRu, String nameEn, String descriptionTm, String descriptionRu, String descriptionEn, String image, double price, double count, double rating,
      int discount, double discountPrice, String category, var values,
      [double quantityStep = 1.0]) {
    if (_items.containsKey(id)) {
    } else {
      _price = _price + (count * price);
      if (discount == 0) {
        _total_price = _total_price + (count * price);
      } else {
        _dis = _dis + ((count * price) - (count * discountPrice));
        _total_price = _total_price + (count * discountPrice);
      }
      _myid.add(id);
      _items.putIfAbsent(
        id,
        () => products(
            id: id,
            name_tm: nameTm,
            name_ru: nameRu,
            name_en: nameEn,
            description_tm: descriptionTm,
            description_ru: descriptionRu,
            description_en: descriptionEn,
            image: image,
            price: price,
            count: count,
            rating: rating,
            discount: discount,
            discount_price: discountPrice,
            category: category,
            quantity_step: quantityStep,
            values: values),
      );
      notifyListeners();
    }
  }

  void addItem(int id, String nameTm, String nameRu, String nameEn, String descriptionTm, String descriptionRu, String descriptionEn, String image, double price, double count, double rating,
      int discount, double discountPrice, String category, var values,
      [double quantityStep = 1.0]) {
    // Eger haryt sebetde bar bolsa, onun oz adimini ulanyarys.
    final double step = stepOf(_items.containsKey(id) ? _items[id]!.quantity_step : quantityStep);

    _price = _price + (price * step);
    if (discount == 0) {
      _total_price = _total_price + (price * step);
    } else {
      _dis = _dis + ((price - discountPrice) * step);
      _total_price = _total_price + (discountPrice * step);
    }
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingCartItem) => products(
            id: existingCartItem.id,
            name_tm: existingCartItem.name_tm,
            name_ru: existingCartItem.name_ru,
            name_en: existingCartItem.name_en,
            description_tm: existingCartItem.description_tm,
            description_ru: existingCartItem.description_ru,
            description_en: existingCartItem.description_en,
            image: existingCartItem.image,
            price: existingCartItem.price,
            count: roundQty(existingCartItem.count + step),
            rating: existingCartItem.rating,
            discount: existingCartItem.discount,
            discount_price: existingCartItem.discount_price,
            category: existingCartItem.category,
            quantity_step: existingCartItem.quantity_step,
            values: existingCartItem.values),
      );
      DatabaseHelper.updateItem(id, _items[id]!.count);
    } else {
      _myid.add(id);
      _items.putIfAbsent(
        id,
        () => products(
            id: id,
            name_tm: nameTm,
            name_ru: nameRu,
            name_en: nameEn,
            description_tm: descriptionTm,
            description_ru: descriptionRu,
            description_en: descriptionEn,
            image: image,
            price: price,
            count: step,
            rating: rating,
            discount: discount,
            discount_price: discountPrice,
            category: category,
            quantity_step: step,
            values: values),
      );
      DatabaseHelper.createItem(id, nameTm, nameRu, nameEn, descriptionTm, descriptionRu, descriptionEn, image, price, step, rating, discount, discountPrice, category, step);
    }
    notifyListeners();
  }

  void removeItem(
    int id,
    double count,
  ) {
    if (_items.containsKey(id)) {
      final double step = stepOf(_items[id]!.quantity_step);
      // Bir adimdan kop bolsa - adim boyunca azaldyarys, yogsam sebetden ayyrylyar.
      if (_items[id]!.count - step > 0.0001) {
        // _total_price=_total_price - _items[id]!.price;
        _price = _price - (_items[id]!.price * step);
        if (_items[id]!.discount == 0) {
          _total_price = _total_price - (_items[id]!.price * step);
        } else {
          _dis = _dis - ((_items[id]!.price - _items[id]!.discount_price) * step);
          _total_price = _total_price - (_items[id]!.discount_price * step);
        }
        _items.update(
          id,
          (existingCartItem) => products(
              id: existingCartItem.id,
              name_tm: existingCartItem.name_tm,
              name_ru: existingCartItem.name_ru,
              name_en: existingCartItem.name_en,
              description_tm: existingCartItem.description_tm,
              description_ru: existingCartItem.description_ru,
              description_en: existingCartItem.description_en,
              image: existingCartItem.image,
              price: existingCartItem.price,
              count: roundQty(existingCartItem.count - step),
              rating: existingCartItem.rating,
              discount: existingCartItem.discount,
              discount_price: existingCartItem.discount_price,
              category: existingCartItem.category,
              quantity_step: existingCartItem.quantity_step,
              values: existingCartItem.values),
        );
        DatabaseHelper.updateItem(id, _items[id]!.count);
      } else {
        _price = _price - _items[id]!.price * _items[id]!.count;
        if (_items[id]!.discount == 0) {
          _total_price = _total_price - _items[id]!.price * _items[id]!.count;
        } else {
          _dis = _dis - ((_items[id]!.price * _items[id]!.count) - (_items[id]!.discount_price * _items[id]!.count));
          _total_price = _total_price - _items[id]!.discount_price * _items[id]!.count;
        }
        _myid.remove(id);
        _items.remove(id);
        DatabaseHelper.deleteItem(id);
      }
      notifyListeners();
    }
  }

  void removeItem2(int id) {
    _myid.remove(id);
    //  DatabaseHelper.deleteFavor(id);
    _items.remove(id);

    notifyListeners();
  }

  void clearItem() {
    _dis = 0.00;
    _price = 0.00;
    _total_price = 0.00;
    _myid.clear();
    _items.clear();
    DatabaseHelper.deleteItemAll();

    notifyListeners();
  }

  void increment() {
    _page = 1;
    notifyListeners();
  }

  void decrement() {
    _page = 0;
    notifyListeners();
  }

  void increment_cart() {
    _page_cart = 1;
    notifyListeners();
  }

  void decrement_cart() {
    _page_cart = 0;
    notifyListeners();
  }

  void in_page_log() {
    _page_log = 1;
    notifyListeners();
  }

  void dec_page_log() {
    _page_log = 0;
    notifyListeners();
  }

  void in_page_log2() {
    _page_log2 = 1;
    notifyListeners();
  }

  void dec_page_log2() {
    _page_log2 = 0;
    notifyListeners();
  }

  void setTm() {
    _dil = 1;
    DatabaseHelper.updateDil(1, 1);
    notifyListeners();
  }

  void setRu() {
    _dil = 0;
    DatabaseHelper.updateDil(1, 0);
    notifyListeners();
  }

  void setEn() {
    _dil = 2;
    DatabaseHelper.updateDil(1, 2);
    notifyListeners();
  }
}
