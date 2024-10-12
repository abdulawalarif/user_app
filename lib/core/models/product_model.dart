import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel with ChangeNotifier {
  String id;
  String name;
  double price;
  String brand;
  String description;
  List<String>? imageUrls;
  String category;
    bool isPopular;

  ProductModel(
      {this.id = '',
      this.name = '',
      this.price = 0,
      this.brand = '',
      this.description = '',
      this.imageUrls,
      this.category = '',
        this.isPopular = false,
     });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
