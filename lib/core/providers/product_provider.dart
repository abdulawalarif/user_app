import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isFetched = false;

  List<ProductModel> get products => _products;

  List<ProductModel> get popularProducts =>
      _products.where((element) => element.isPopular).toList();

  ProductModel findById(String id) =>
      _products.firstWhere((element) => element.id == id);

  List<ProductModel> findByCategory(String categoryTitle) => _products
      .where((element) =>
          element.category.toLowerCase().contains(categoryTitle.toLowerCase()))
      .toList();

  List<ProductModel> searchQuery(String query) => _products
      .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  Future<void> fetchProducts() async {
    if (_isFetched) return;
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        _products.insert(0, ProductModel.fromJson(element.data()));
      });
      _isFetched = true;
      notifyListeners();
    });
  }
}
