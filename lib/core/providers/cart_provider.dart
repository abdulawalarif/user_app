import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/core/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  
  Map<String, CartModel> _cartItems = {};
  CartProvider() {
    loadCart();
  }
  // Getter to retrieve cart items
  Map<String, CartModel> get getCartItems => _cartItems;

  // Getter to calculate subtotal
  double get subTotal {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  // Getter for the total number of unique items in the cart
  int get totalUniqueItems => _cartItems.length;

  // Check if an item is in the cart
  bool isInCart(id) => _cartItems.containsKey(id);

  // Load cart data from SharedPreferences
  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cartItems');
    if (cartData != null) {
      Map<String, dynamic> decodedCartData = json.decode(cartData);
      _cartItems = decodedCartData.map((key, value) =>
          MapEntry(key, CartModel.fromMap(Map<String, dynamic>.from(value))));
      notifyListeners();
    }
  }

  // Save cart data to SharedPreferences
  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> cartData =
        _cartItems.map((key, value) => MapEntry(key, value.toMap()));
    await prefs.setString('cartItems', json.encode(cartData));
  }

  // Add or remove item from the cart
  void addAndRemoveItem(CartModel cartModel) {
    if (isInCart(cartModel.id)) {
      _cartItems.remove(cartModel.id);
    } else {
      _cartItems.putIfAbsent(cartModel.id, () => cartModel);
    }
    notifyListeners();
    _saveCart();
  }

  // Update the cart item
  void updateCart(CartModel cartModel) {
    _cartItems.update(cartModel.id, (existingCartItem) => cartModel);
    notifyListeners();
    _saveCart();
  }

  // Remove item from the cart
  void removeFromCart(id) {
    _cartItems.remove(id);
    notifyListeners();
    _saveCart();
  }

  // Remove all items from the cart
  void removeAll() {
    _cartItems.clear();
    notifyListeners();
    _saveCart();
  }
}
