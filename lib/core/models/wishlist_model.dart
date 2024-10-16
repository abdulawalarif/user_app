import 'package:flutter/material.dart';

class WishlistModel with ChangeNotifier {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int sales;

  WishlistModel({
    this.id = '',
    this.name = '',
    this.imageUrl = '',
    this.price = 0.0,
    this.sales = 0,
  });

  // Convert WishlistModel to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'price': price,
    'sales': sales,
  };

  // Create a WishlistModel from JSON
  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      sales: json['sales'],
    );
  }
}
