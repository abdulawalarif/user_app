import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  // Convert CartModel to a map for saving
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  // Create CartModel from a map
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
