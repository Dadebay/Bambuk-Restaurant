import 'package:bamboo/values/models.dart';

class Cart {
  double total;
  int totalProductsCount;
  Map<int, products> product;

  Cart({this.total = 0.00, this.totalProductsCount = 0, required this.product});

  factory Cart.fromLocal(List<Map<String, dynamic>> json) {
    Iterable productsIterable = json;
    dynamic totalRaw = json.length;

    // ignore: prefer_for_elements_to_map_fromiterable
    Map<int, products> cartProducts = Map.fromIterable(productsIterable, key: (mapCartProduct) => mapCartProduct['productId'], value: (mapCartProduct) => products.fromLocal(mapCartProduct));
    return Cart(total: totalRaw is int ? totalRaw.toDouble() : totalRaw, totalProductsCount: cartProducts.length, product: cartProducts);
  }
}
