import 'package:flutter/cupertino.dart';

class WishlistModel with ChangeNotifier {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int sales;

  WishlistModel(
      {this.id = '',
      this.name = '',
      this.imageUrl = '',
      this.price = 0,
      this.sales = 0});
}
