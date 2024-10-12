import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:user_app/core/models/wish_model.dart';

class DBHelperWishList {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'wish.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE wish (productId VARCHAR PRIMARY KEY UNIQUE, productName TEXT, initialPrice INTEGER, productPrice INTEGER, quantity INTEGER, image TEXT )');
  }

  Future<Wish> insert(Wish wish) async {

    var dbClient = await db;
    await dbClient!.insert('wish', wish.toMap());
    return wish;
  }

  Future<List<Wish>> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('wish');
    return queryResult.map((e) => Wish.fromMap(e)).toList();
  }

  Future<int> delete(String productId) async {
    var dbClient = await db;
    return await dbClient!.delete('wish', where: 'productId = ?', whereArgs: [productId]);
  }

  Future<int> updateQuantity(Wish wish) async {
    var dbClient = await db;
    return await dbClient!
        .update('wish', wish.toMap(), where: 'productId = ?', whereArgs: [wish.productId]);
  }
}
