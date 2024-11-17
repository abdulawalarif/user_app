import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/core/models/orders_model.dart';
import 'package:dartz/dartz.dart';
import 'firebase_service.dart';


typedef EitherError<T> = Future<Either<String, T>>;
class OrdersProvider with ChangeNotifier {
  final FirebaseFirestore _fireStore = FireStoreService().instance;

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
      await _fireStore.collection('orders').doc(orderId).set(jsonOrderData);
      await _fireStore.collection('users').doc(order.customerId).set(
        {
          'shippingAddress': shippingAddress.toJson(),
          'orders': FieldValue.arrayUnion([orderId]),
        },
        SetOptions(merge: true),
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
      final userDoc = await _fireStore.collection('users').doc(customerId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      final ordersList = userDoc.data()?['orders'] as List<dynamic>? ?? [];
      if (ordersList.isEmpty) {
        return;
      }
      for (final orderId in ordersList) {
        await _fireStore
            .collection('orders')
            .doc(orderId as String)
            .get()
            .then((snapshot) {
          final orderData = OrdersModel.fromJson(snapshot.data()!);
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
      await _fireStore.collection('orders').doc(ordersModel.orderId).update({
        'status': 'confirmedByCustomer',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await _fireStore.collection('users').doc(ordersModel.customerId).update({
        'orders': FieldValue.arrayRemove([ordersModel.orderId]),
      });
      _orderList.removeWhere((order) => order.orderId == ordersModel.orderId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}



