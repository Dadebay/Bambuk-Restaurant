import 'package:bamboo/DB/db.dart';
import 'package:bamboo/values/models.dart';
import 'package:flutter/foundation.dart';

class Favourite with ChangeNotifier, DiagnosticableTreeMixin {
  final List _myid = [];
  List get myid => _myid;

  String phone = "";
  final Map<int, products> _items = {};

  final List<model_address> _address = [];
  List<model_address> get address => _address;

  Map<int, products> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addAddress(String name, String addressTxt) {
    _address.add(model_address(name: name, address_txt: addressTxt));
    notifyListeners();
  }

  void clearAddress() {
    _address.clear();
    notifyListeners();
  }

  void addSplash(int id, String nameTm, String nameRu, String nameEn, var descriptionTm, var descriptionRu, var descriptionEn, String image, double price, int count, double rating, int discount,
      double discountPrice, String category, var values) {
    if (_items.containsKey(id)) {
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
            count: count,
            rating: rating,
            discount: discount,
            discount_price: discountPrice,
            category: category,
            values: values),
      );
      notifyListeners();
    }
  }

  void addItem(int id, String nameTm, String nameRu, String nameEn, var descriptionTm, var descriptionRu, var descriptionEn, String image, double price, int count, double rating, int discount,
      double discountPrice, String category, var values) {
    _myid.add(id);
    DatabaseHelper.createFavor(id, nameTm, nameRu, nameEn, descriptionTm, descriptionRu, descriptionEn, image, price, count, rating, discount, discountPrice, category);
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

  void clearFav() {
    _items.clear();
    _myid.clear();
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('myid', _myid));
    properties.add(ObjectFlagProperty<Map<int, products>>.has('items', _items));
    properties.add(IterableProperty('address', _address));
    properties.add(StringProperty('phone', phone));
    properties.add(IntProperty('itemCount', itemCount));
  }
}
