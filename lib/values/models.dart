class items {
  String id;
  String name;
  String price;
  String image;
  String content;
  String rate;
  int count;
  items({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.content,
    required this.rate,
    required this.count,
  });
}

class categorys {
  int id;
  String name_tm;
  String name_ru;
  String name_en;
  String image;
  var children;
  categorys({required this.id, required this.name_tm, required this.name_ru, required this.name_en, required this.image, required this.children});
}

class sliders {
  int id;
  String image;
  String imageRu;
  String imageEn;
  sliders({
    required this.id,
    required this.image,
    required this.imageRu,
    required this.imageEn,
  });
}

class ColorPick {
  int id;
  String colors;
  ColorPick({required this.id, required this.colors});
}

class model_address {
  String name;
  String address_txt;
  model_address({required this.name, required this.address_txt});
}

class CommentBanner {
  int id;
  String nameTm;
  String nameRu;
  String contentTm;
  String contentRu;
  String imageTm;
  String imageRu;
  CommentBanner({required this.id, required this.nameTm, required this.nameRu, required this.contentTm, required this.contentRu, required this.imageTm, required this.imageRu});
}

class products {
  int id;
  String name_tm;
  String name_ru;
  String name_en;
  var description_tm;
  var description_ru;
  var description_en;
  String image;
  double price;
  int count;
  double rating;
  int discount;
  double discount_price;
  String category;
  var values;
  products(
      {required this.id,
      required this.name_tm,
      required this.name_ru,
      required this.name_en,
      required this.description_tm,
      required this.description_ru,
      required this.description_en,
      required this.image,
      required this.price,
      required this.count,
      required this.rating,
      required this.discount,
      required this.discount_price,
      required this.category,
      required this.values});
  factory products.fromLocal(Map<String, dynamic> json) {
    return products(
      id: json['id'],
      name_tm: json['name_tm'],
      name_ru: json['name_ru'],
      name_en: json['name_en'],
      description_tm: json['description_tm'],
      description_ru: json['description_ru'],
      description_en: json['description_en'],
      image: json['image'],
      price: json['price'],
      count: json['count'],
      rating: json['rating'],
      discount: json['discount'],
      discount_price: json['discount_price'],
      category: json['category'],
      values: json['values'],
    );
  }
}

class orders {
  int id;
  String date;
  int status_id;
  String status;
  String status_ru;
  String order_no;
  var my_products;
  String total_price;
  orders({required this.id, required this.date, required this.status_id, required this.status, required this.status_ru, required this.order_no, required this.my_products, required this.total_price});
}

class order_items {
  String name_tm;
  String name_ru;
  String image;
  String price;
  String count;
  order_items({
    required this.name_tm,
    required this.name_ru,
    required this.image,
    required this.price,
    required this.count,
  });
}

class category_home {
  int id;
  String name_tm;
  String name_ru;
  category_home({required this.id, required this.name_tm, required this.name_ru});
}

class category_home2 {
  int id;
  String name_tm;
  String name_ru;
  String name_en;

  category_home2({required this.id, required this.name_tm, required this.name_ru, required this.name_en});
}

class help {
  int id;
  String name_tm;
  String name_ru;
  String name_en;
  String body_tm;
  String body_ru;
  String body_en;
  help({
    required this.id,
    required this.name_tm,
    required this.name_ru,
    required this.name_en,
    required this.body_tm,
    required this.body_ru,
    required this.body_en,
  });
}

class new_post {
  int id;
  String name_tm;
  String name_ru;
  String body_tm;
  String body_ru;
  String date;
  String view;
  String image;
  new_post({
    required this.id,
    required this.name_tm,
    required this.name_ru,
    required this.body_tm,
    required this.body_ru,
    required this.date,
    required this.view,
    required this.image,
  });
}
