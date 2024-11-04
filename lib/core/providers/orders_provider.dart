import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:user_app/core/models/orders_model.dart';
import 'package:dartz/dartz.dart';

typedef EitherError<T> = Future<Either<String,T>>;
class OrdersProvider with ChangeNotifier {
  Future<void> addOrdersToDatabase( ) async {
  
    notifyListeners();
  }


   
Future<void> addOrder(OrdersModel order) async {
  try {
    final jsonOrderData = order.toJson();
    jsonOrderData['products'] = order.products.map((product) => product.toJson()).toList();
    jsonOrderData['shippingAddress'] = order.shippingAddress.toJson();
    await FirebaseFirestore.instance.collection('orders').add(jsonOrderData);
    print("Order added successfully!");
  } catch (e) {
    print("Failed to add order: $e");
  }
}
}


