import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:bamboo/DB/db.dart';
import 'package:bamboo/values/models.dart';

class ProvItem with ChangeNotifier, DiagnosticableTreeMixin {
  double _total_price = 0.00;
  double get total_price => _total_price;

  double _price = 0.00;
  double get price => _price;

  double _dis = 0.00;
  double get dis => _dis;

  List _myid = [];
  List get myid => _myid;

  Map<int, products> _items = {};

  Map<int, products> get items {
    return {..._items};
  }

  void addSplash(
      int id,
      String name_tm,
      String name_ru,
      String name_en,
      String description_tm,
      String description_ru,
      String description_en,
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
      _price = _price + (count * price);
      if (discount == 0) {
        _total_price = _total_price + (count * price);
      } else {
        _dis = _dis + ((count * price) - (count * discount_price));
        _total_price = _total_price + (count * discount_price);
      }
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
      String description_tm,
      String description_ru,
      String description_en,
      String image,
      double price,
      int count,
      double rating,
      int discount,
      double discount_price,
      String category,
      var values) {
    _price = _price + price;
    if (discount == 0) {
      _total_price = _total_price + price;
    } else {
      _dis = _dis + (price - discount_price);
      _total_price = _total_price + discount_price;
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
            count: existingCartItem.count + 1,
            rating: existingCartItem.rating,
            discount: existingCartItem.discount,
            discount_price: existingCartItem.discount_price,
            category: existingCartItem.category,
            values: existingCartItem.values),
      );
      DatabaseHelper.updateItem(id, _items[id]!.count + 1);
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
            count: 1,
            rating: rating,
            discount: discount,
            discount_price: discount_price,
            category: category,
            values: values),
      );
      DatabaseHelper.createItem(
          id,
          name_tm,
          name_ru,
          name_en,
          description_tm,
          description_ru,
          description_en,
          image,
          price,
          1,
          rating,
          discount,
          discount_price,
          category);
    }
    notifyListeners();
  }

  void removeItem(
    int id,
    int count,
  ) {
    if (_items.containsKey(id)) {
      if (_items[id]!.count != 1) {
        // _total_price=_total_price - _items[id]!.price;
        _price = _price - _items[id]!.price;
        if (_items[id]!.discount == 0) {
          _total_price = _total_price - _items[id]!.price;
        } else {
          _dis = _dis - (_items[id]!.price - _items[id]!.discount_price);
          _total_price = _total_price - _items[id]!.discount_price;
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
              count: existingCartItem.count - 1,
              rating: existingCartItem.rating,
              discount: existingCartItem.discount,
              discount_price: existingCartItem.discount_price,
              category: existingCartItem.category,
              values: existingCartItem.values),
        );
        DatabaseHelper.updateItem(id, _items[id]!.count - 1);
      } else {
        _price = _price - _items[id]!.price * _items[id]!.count;
        if (_items[id]!.discount == 0) {
          _total_price = _total_price - _items[id]!.price * _items[id]!.count;
        } else {
          _dis = _dis -
              ((_items[id]!.price * _items[id]!.count) -
                  (_items[id]!.discount_price * _items[id]!.count));
          _total_price =
              _total_price - _items[id]!.discount_price * _items[id]!.count;
        }
        _myid.remove(id);
        _items.remove(id);
        DatabaseHelper.deleteItem(id);
      }
      notifyListeners();
    }
  }

  void removeItem2(int id) {
    _price = _price - _items[id]!.price * _items[id]!.count;
    if (_items[id]!.discount == 0) {
      _total_price = _total_price - _items[id]!.price * _items[id]!.count;
    } else {
      _dis = _dis -
          ((_items[id]!.price * _items[id]!.count) -
              (_items[id]!.discount_price * _items[id]!.count));
      _total_price =
          _total_price - _items[id]!.discount_price * _items[id]!.count;
    }
    _myid.remove(id);
    _items.remove(id);
    DatabaseHelper.deleteItem(id);

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
}
