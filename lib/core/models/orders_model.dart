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
      :customersId = json['customersId']??"",
        thumbnailImageUrl = json['thumbnailImageUrl']??"",
        nameOfTheProduct = json['nameOfTheProduct']??"",
        totalItemsOrdered = json['totalItemsOrdered']??"",
        orderDate = json['orderDate']??"",
        price = json['price']??"";
  Map<String, dynamic> toJson() => {
    'customersId': customersId,
    'thumbnailImageUrl': thumbnailImageUrl,
    'nameOfTheProduct': nameOfTheProduct,
    'totalItemsOrdered': totalItemsOrdered,
    'orderDate': orderDate,
    'price': price,
  };
}
