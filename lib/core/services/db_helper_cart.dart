import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:user_app/core/models/cart_model.dart';

class DBHelperCart {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (productId VARCHAR PRIMARY KEY UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, image TEXT )');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        // TODO    DBHelperCart.getCartList (package:user_app/core/services/db_helper_cart.dart:44:23)
        await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(String productId) async {
    var dbClient = await db;
    return await dbClient!
        .delete('cart', where: 'productId = ?', whereArgs: [productId]);
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await db;
    return await dbClient!.update('cart', cart.toMap(),
        where: 'productId = ?', whereArgs: [cart.productId]);
  }
}
