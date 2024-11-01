import 'package:freezed_annotation/freezed_annotation.dart';
part 'orders_model.freezed.dart';
part 'orders_model.g.dart';

@freezed
class OrdersModel with _$OrdersModel {
  const factory OrdersModel({
    required String orderId,
    required String customerId,
    required DateTime orderDate,
    required int totalItemsOrdered,
    required double totalAmount,
    required String paymentStatus,
    required String status,
    required String createdAt,
    required String? updatedAt,
    required List<Product> products,
    required ShippingAddress shippingAddress,
  }) = _OrdersModel;

  factory OrdersModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersModelFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String productId,
    required String productName,
    required int quantity,
    required double pricePerUnit,
    required double totalPriceForThisItem,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class ShippingAddress with _$ShippingAddress {
  const factory ShippingAddress({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    required double? latitude,
    required double? longitude,
    required String formattedAddress,
  }) = _ShippingAddress;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);
}
