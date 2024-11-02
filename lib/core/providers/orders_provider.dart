import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:user_app/core/models/orders_model/orders_model.dart';
import 'package:dartz/dartz.dart';

typedef EitherError<T> = Future<Either<String,T>>;
class OrdersProvider with ChangeNotifier {
  Future<void> addOrdersToDatabase( ) async {
  
    notifyListeners();
  }
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




 void addDummyData() {

  final dummyOrder = OrdersModel(
    orderId: "ORD123457",
    customerId: "CUST78910",
    orderDate: DateTime.now(),
    totalItemsOrdered: 3,
    totalAmount: 299.99,
    paymentStatus: "Paid",
    status: "Shipped",
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    products: [
      Product(
        productId: "PROD1",
        productName: "Wireless Earbuds",
        quantity: 1,
        pricePerUnit: 99.99,
        totalPriceForThisItem: 99.99,
      ),
      Product(
        productId: "PROD2",
        productName: "Smart Watch",
        quantity: 1,
        pricePerUnit: 149.99,
        totalPriceForThisItem: 149.99,
      ),
      Product(
        productId: "PROD3",
        productName: "Phone Case",
        quantity: 1,
        pricePerUnit: 49.99,
        totalPriceForThisItem: 49.99,
      ),
    ],
    shippingAddress: ShippingAddress(
      addressLine1: "123 Elm Street",
      addressLine2: "Apt 4B",
      city: "Los Angeles",
      state: "CA",
      postalCode: "90001",
      country: "USA",
      latitude: 34.0522,
      longitude: -118.2437,
      formattedAddress: "123 Elm Street, Apt 4B, Los Angeles, CA 90001, USA",
    ),
  );

  addOrder(dummyOrder);
}
