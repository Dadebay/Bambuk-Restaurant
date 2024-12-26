import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        productId INTEGER,
        name_tm TEXT,
        name_ru TEXT,
        name_en TEXT,
        description_tm TEXT,
        description_ru TEXT,
        description_en TEXT,
        image TEXT,
        price REAL,
        count INTEGER,
        rating REAL,
        discount INTEGER,
        discount_price REAL,
        category TEXT
      )
      """);
    await database.execute("""CREATE TABLE favourites(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        productId INTEGER,
        name_tm TEXT,
        name_ru TEXT,
        name_en TEXT,
        description_tm TEXT,
        description_ru TEXT,
        description_en TEXT,
        image TEXT,
        price REAL,
        count INTEGER,
        rating REAL,
        discount INTEGER,
        discount_price REAL,
        category TEXT
      )
      """);
    await database.execute("""CREATE TABLE category(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        categoryId INTEGER,
        name TEXT 
      )
      """);
    await database.execute("""CREATE TABLE diller(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        productId INTEGER,
        dil INTEGER 
      )
      """);
    await database.execute("""CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        productId INTEGER,
        name TEXT,
        surname TEXT,
        email TEXT,
        username TEXT,
        token TEXT  
      )
      """);
    await database.execute("""CREATE TABLE adres(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        address_txt TEXT 
      )
      """);
    await database.execute("""CREATE TABLE address(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        address_txt TEXT 
      )
      """);
  }
// id: the id of a item s
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'nabindhal.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  //my user  insert
  static Future<int> addUser(int productId, String name, String surname, String email, String username, String token) async {
    final db = await DatabaseHelper.db();
    final data = {
      'productId': productId,
      'name': name,
      'surname': surname,
      'email': email,
      'username': username,
      'token': token,
    };
    final id = await db.insert('user', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> add_address(
    String name,
    String addressTxt,
  ) async {
    final db = await DatabaseHelper.db();
    final data = {
      'name': name,
      'address_txt': addressTxt,
    };
    final id = await db.insert('adres', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = await DatabaseHelper.db();
    return db.query('user', orderBy: "id");
  }

  static Future<void> deleteUserAll() async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("user");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

// 863285198
  // Create new item
  static Future<int> createItem(int productId, String nameTm, String nameRu, String nameEn, String descriptionTm, String descriptionRu, String descriptionEn, String image, double price, int count,
      double rating, int discount, double discountPrice, String category) async {
    final db = await DatabaseHelper.db();
    final data = {
      'productId': productId,
      'name_tm': nameTm,
      'name_ru': nameRu,
      'name_en': nameEn,
      'description_tm': descriptionTm,
      'description_ru': descriptionRu,
      'description_en': descriptionEn,
      'image': image,
      'price': price,
      'count': count,
      'rating': rating,
      'discount': discount,
      'discount_price': discountPrice,
      'category': category
    };
    final id = await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Update an item by id
  static Future<int> updateItem(int id, int count) async {
    final db = await DatabaseHelper.db();

    final data = {'count': count};

    final result = await db.update('items', data, where: "productId = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateDil(int id, int count) async {
    final db = await DatabaseHelper.db();

    final data = {'dil': count};

    final result = await db.update('diller', data, where: "productId = ?", whereArgs: [id]);
    return result;
  }

  //add favourites
  static Future<int> createFavor(int productId, String nameTm, String nameRu, String nameEn, String descriptionTm, String descriptionRu, String descriptionEn, String image, double price, int count,
      double rating, int discount, double discountPrice, String category) async {
    final db = await DatabaseHelper.db();
    final data = {
      'productId': productId,
      'name_tm': nameTm,
      'name_ru': nameRu,
      'name_en': nameEn,
      'description_tm': descriptionTm,
      'description_ru': descriptionRu,
      'description_en': descriptionEn,
      'image': image,
      'price': price,
      'count': count,
      'rating': rating,
      'discount': discount,
      'discount_price': discountPrice,
      'category': category
    };
    final id = await db.insert('favourites', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createCategory(int productId, String name) async {
    final db = await DatabaseHelper.db();
    final data = {'productId': productId, 'name': name};
    final id = await db.insert('category', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createDill(int productId, int name) async {
    final db = await DatabaseHelper.db();
    final data = {'productId': productId, 'dil': name};
    final id = await db.insert('diller', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getAddress() async {
    final db = await DatabaseHelper.db();
    return db.query('adres', orderBy: "id");
  }

  // read favourites
  static Future<List<Map<String, dynamic>>> getFavor() async {
    final db = await DatabaseHelper.db();
    return db.query('favourites', orderBy: "id");
  }

  //read dill
  static Future<List<Map<String, dynamic>>> getDiller() async {
    final db = await DatabaseHelper.db();
    return db.query('diller');
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Delete item
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items", where: "productId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  //delete itemall
  static Future<void> deleteItemAll() async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  //delete favourites
  static Future<void> deleteFavor(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("favourites", where: "productId = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
