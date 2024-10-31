import 'package:flutter/cupertino.dart';

class OrdersModel with ChangeNotifier {
  String customersId;
  String thumbnailImageUrl;
  String nameOfTheProduct;
  int totalItemsOrdered;
  String orderDate;
  String? price;

  OrdersModel({
    this.customersId = '',
    this.thumbnailImageUrl = '',
    this.nameOfTheProduct = '',
    this.totalItemsOrdered = 1,
    this.orderDate = '',
    this.price = '',
  });

  OrdersModel.fromJson(Map<String, dynamic> json)
      : customersId = json['customersId'] ?? "",
        thumbnailImageUrl = json['thumbnailImageUrl'] ?? "",
        nameOfTheProduct = json['nameOfTheProduct'] ?? "",
        totalItemsOrdered = json['totalItemsOrdered'] ?? "",
        orderDate = json['orderDate'] ?? "",
        price = json['price'] ?? "";
  Map<String, dynamic> toJson() => {
        'customersId': customersId,
        'thumbnailImageUrl': thumbnailImageUrl,
        'nameOfTheProduct': nameOfTheProduct,
        'totalItemsOrdered': totalItemsOrdered,
        'orderDate': orderDate,
        'price': price,
      };
}

///order{
// user{},
// itmes:[
// {},//one or multiple it doesn't matter 
// {}
// ]

// }




// To parse this JSON data, do
//
//     final ordersModel = ordersModelFromJson(jsonString);

// import 'dart:convert';

// OrdersModel ordersModelFromJson(String str) => OrdersModel.fromJson(json.decode(str));

// String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

// class OrdersModel {
//     String? orderId;
//     String? customerId;
//     DateTime? orderDate;
//     int? totalItemsOrdered;
//     int? totalAmount;
//     String? paymentStatus;
//     String? status;
//     String? createdAt;
//     String? updatedAt;
//     List<Product>? products;
//     ShippingAddress? shippingAddress;

//     OrdersModel({
//         this.orderId,
//         this.customerId,
//         this.orderDate,
//         this.totalItemsOrdered,
//         this.totalAmount,
//         this.paymentStatus,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.products,
//         this.shippingAddress,
//     });

//     factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
//         orderId: json["orderId"],
//         customerId: json["customerId"],
//         orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
//         totalItemsOrdered: json["totalItemsOrdered"],
//         totalAmount: json["totalAmount"],
//         paymentStatus: json["paymentStatus"],
//         status: json["status"],
//         createdAt: json["createdAt"],
//         updatedAt: json["updatedAt"],
//         products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
//         shippingAddress: json["shippingAddress"] == null ? null : ShippingAddress.fromJson(json["shippingAddress"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "orderId": orderId,
//         "customerId": customerId,
//         "orderDate": orderDate?.toIso8601String(),
//         "totalItemsOrdered": totalItemsOrdered,
//         "totalAmount": totalAmount,
//         "paymentStatus": paymentStatus,
//         "status": status,
//         "createdAt": createdAt,
//         "updatedAt": updatedAt,
//         "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
//         "shippingAddress": shippingAddress?.toJson(),
//     };
// }

// class Product {
//     String? productId;
//     String? productName;
//     int? quantity;
//     int? pricePerUnit;
//     int? totalPriceForThisItem;

//     Product({
//         this.productId,
//         this.productName,
//         this.quantity,
//         this.pricePerUnit,
//         this.totalPriceForThisItem,
//     });

//     factory Product.fromJson(Map<String, dynamic> json) => Product(
//         productId: json["productId"],
//         productName: json["productName"],
//         quantity: json["quantity"],
//         pricePerUnit: json["pricePerUnit"],
//         totalPriceForThisItem: json["totalPriceForThisItem"],
//     );

//     Map<String, dynamic> toJson() => {
//         "productId": productId,
//         "productName": productName,
//         "quantity": quantity,
//         "pricePerUnit": pricePerUnit,
//         "totalPriceForThisItem": totalPriceForThisItem,
//     };
// }

// class ShippingAddress {
//     String? addressLine1;
//     String? addressLine2;
//     String? city;
//     String? state;
//     String? postalCode;
//     String? country;
//     double? latitude;
//     double? longitude;
//     String? formattedAddress;

//     ShippingAddress({
//         this.addressLine1,
//         this.addressLine2,
//         this.city,
//         this.state,
//         this.postalCode,
//         this.country,
//         this.latitude,
//         this.longitude,
//         this.formattedAddress,
//     });

//     factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
//         addressLine1: json["addressLine1"],
//         addressLine2: json["addressLine2"],
//         city: json["city"],
//         state: json["state"],
//         postalCode: json["postalCode"],
//         country: json["country"],
//         latitude: json["latitude"]?.toDouble(),
//         longitude: json["longitude"]?.toDouble(),
//         formattedAddress: json["formattedAddress"],
//     );

//     Map<String, dynamic> toJson() => {
//         "addressLine1": addressLine1,
//         "addressLine2": addressLine2,
//         "city": city,
//         "state": state,
//         "postalCode": postalCode,
//         "country": country,
//         "latitude": latitude,
//         "longitude": longitude,
//         "formattedAddress": formattedAddress,
//     };
// }
