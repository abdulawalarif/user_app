import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/product_model.dart';
import 'package:user_app/core/providers/firebase_service.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider() {
    fetchProducts();
  }

  final FirebaseFirestore _fireStore = FireStoreService().instance;

  final List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  List<ProductModel> get popularProducts =>
      _products.where((element) => element.isPopular).toList();

  ProductModel findById(String id) =>
      _products.firstWhere((element) => element.id == id);

  List<ProductModel> findByCategory(String categoryTitle) => _products
      .where((element) =>
          element.category.toLowerCase().contains(categoryTitle.toLowerCase()))
      .toList();


//TODO fixing the search query 
// And writing proper way of searching the products..

  List<ProductModel> searchQuery(String query) => _products
      .where((element) =>
          element.name.toLowerCase().contains(query.toLowerCase()) ||
          element.category.toLowerCase().contains(query.toLowerCase()) ||
          element.brand.toLowerCase().contains(query.toLowerCase()))
      .toList();

  Future<void> fetchProducts() async {
    await _fireStore.collection('products').get().then((snapshot) {
      for (var element in snapshot.docs) {
        _products.insert(0, ProductModel.fromJson(element.data()));
      }
      notifyListeners();
    });
  }
}
