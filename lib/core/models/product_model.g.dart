// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
 /// print(json['imageUrls'].length);
  List<String>imageUrlOfProductsForFetching=[];
  for(int i =0; i<json['imageUrls'].length; i++){
    imageUrlOfProductsForFetching.add(json['imageUrls'][i]);
  }
  return ProductModel(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    brand: json['brand'] as String,
    description: json['description'] as String,
    imageUrls: imageUrlOfProductsForFetching,
    category: json['category'] as String,
      isPopular: json['isPopular'] as bool,
   );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'brand': instance.brand,
      'description': instance.description,
      'imageUrls': instance.imageUrls,
      'category': instance.category,
        'isPopular': instance.isPopular,
     };
