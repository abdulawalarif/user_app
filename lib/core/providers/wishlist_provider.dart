import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/core/models/wishlist_model.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> _wishListItems = {};

  // Getter to access the wishlist
  Map<String, WishlistModel> get getwishListItems => _wishListItems;

  // Initialize WishlistProvider by loading data from SharedPreferences
  WishlistProvider() {
    loadWishlist();
  }

  // Add or remove an item from the wishlist and persist the change
  void addAndRemoveItem(WishlistModel wishlistModel) async {
    if (isInWishList(wishlistModel.id)) {
      removeWishlistItem(wishlistModel.id);
    } else {
      _wishListItems.putIfAbsent(wishlistModel.id, () => wishlistModel);
    }
    await saveWishlist();
    notifyListeners();
  }

  // Remove an item by its ID and persist the change
  void removeWishlistItem(String productId) async {
    _wishListItems.remove(productId);
    await saveWishlist();
    notifyListeners();
  }

  // Clear all wishlist items and persist the change
  void clearWishlist() async {
    _wishListItems.clear();
    await saveWishlist();
    notifyListeners();
  }

  // Check if an item is in the wishlist
  bool isInWishList(String productId) => _wishListItems.containsKey(productId);

  // Save wishlist to SharedPreferences
  Future<void> saveWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(
      _wishListItems.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString('wishlist', encodedData);
  }

  Future<void> loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('wishlist');

    if (encodedData != null) {
      Map<String, dynamic> decodedData = json.decode(encodedData);
      _wishListItems = decodedData.map((key, value) =>
          MapEntry(key, WishlistModel.fromJson(value as Map<String, dynamic>)));
      notifyListeners();
    }
  }
}
