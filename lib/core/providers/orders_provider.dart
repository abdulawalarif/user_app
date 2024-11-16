import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/core/models/orders_model.dart';
import 'package:dartz/dartz.dart';

typedef EitherError<T> = Future<Either<String, T>>;

class OrdersProvider with ChangeNotifier {
  Future<void> addOrder(
      {required OrdersModel order,
      required ShippingAddress shippingAddress}) async {
    try {
      final orderId = order.orderId;
      final jsonOrderData = order.toJson();
      jsonOrderData['products'] =
          order.products.map((product) => product.toJson()).toList();
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(jsonOrderData);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(order.customerId)
          .set(
        {
          'shippingAddress': shippingAddress.toJson(),
          'orders': FieldValue.arrayUnion([orderId]),
        }, // Store as a field directly in the user document
        SetOptions(merge: true), // Only updates fields that are different
      );

      print("Order added successfully!");
    } catch (e) {
      print("Failed to add order: $e");
    }
  }

  Future<void> myOrders() async {
    
  }
}
