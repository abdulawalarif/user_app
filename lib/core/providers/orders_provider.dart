import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/core/models/orders_model.dart';
import 'package:dartz/dartz.dart';

typedef EitherError<T> = Future<Either<String, T>>;

class OrdersProvider with ChangeNotifier {
  List<OrdersModel> _orderList = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<OrdersModel> get orderList => _orderList;

  Future<void> addOrder({
    required OrdersModel order,
    required ShippingAddress shippingAddress,
  }) async {
    try {
      final orderId = order.orderId;
      final jsonOrderData = order.toJson();
      jsonOrderData['products'] =
          order.products.map((product) => product.toJson()).toList();
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(jsonOrderData);

      ///TODO if the internet connectin failed inserting orders into user's collection
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> myOrders({required String customerId}) async {
    _isLoading = true;
    notifyListeners();
    _orderList.clear();
    if (_isFetched) return;
    try {
      //TODO writing some logic if the user do not have any oders on his profile
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      final ordersList = userDoc.data()?['orders'] as List<dynamic>? ?? [];

      if (ordersList.isEmpty) {
        return;
      }

      for (final orderId in ordersList) {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId as String)
            .get()
            .then((snapshot) {
          final orderData = OrdersModel.fromJson(snapshot.data()!);
          // TODO filtering confirms order from the lists and deleting it's instace from the user orders doc id

          _orderList.insert(0, orderData);
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> confirmOrder({required OrdersModel ordersModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(ordersModel.orderId)
          .update({
        'status': 'confirmedByCustomer',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(ordersModel.customerId)
          .update({
        'orders': FieldValue.arrayRemove([ordersModel.orderId]),
      });
      _orderList.removeWhere((order) => order.orderId == ordersModel.orderId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
