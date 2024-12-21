import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/core/models/orders_model.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'package:rxdart/rxdart.dart';

 

class OrdersProvider with ChangeNotifier {
  final FirebaseFirestore _fireStore = FireStoreService().instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> addOrder({
    required OrdersModel order,
    required UserModel shippingAddress,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final orderId = order.orderId;

      final jsonOrderData = order.toJson();
      jsonOrderData['products'] =
          order.products.map((product) => product.toJson()).toList();
      await _fireStore.collection('orders').doc(orderId).set(jsonOrderData);

      /*
      Here I am storing users oders information under customar accounts also so that one clints app don't get the data of another clinets order in their cache
      */
      // TODO checking is user changed their address?
      //if so callind this method
      await _fireStore.collection('users').doc(order.customerId).update(shippingAddress.toJson());

      await _fireStore.collection('users').doc(order.customerId).set(
        {
         
          'orders': FieldValue.arrayUnion([orderId]),
        },
        SetOptions(merge: true),
     );
    } catch (e) {
      print('Order debug: ${e.toString()}');
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Stream<List<OrdersModel>> streamMyOrders(String customerId) {
  return _fireStore.collection('users').doc(customerId).snapshots().switchMap((userDoc) {
    if (!userDoc.exists) return Stream.value([]);
    final ordersList = userDoc.data()?['orders'] as List<dynamic>? ?? [];
    if (ordersList.isEmpty) return Stream.value([]);
    
    // Stream changes from each order document
    final orderStreams = ordersList.map((orderId) {
      return _fireStore.collection('orders').doc(orderId).snapshots().map((orderDoc) {
        if (orderDoc.exists) {
          return OrdersModel.fromJson(orderDoc.data()!);
        }
        return null; // If order doesn't exist, return null
      });
    }).toList();

    // Combine all individual order streams into one list
    return CombineLatestStream.list(orderStreams).map((orders) {
      // Filter out null orders (in case some orders are deleted)
      return orders.whereType<OrdersModel>().toList();
    });
  });
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
    } catch (e) {
      rethrow;
    }
  }



  Stream<OrdersModel> streamOrderStatus(String orderId) {
  return _fireStore.collection('orders').doc(orderId).snapshots().map((doc) {
    if (doc.exists) {
      return OrdersModel.fromJson(doc.data()!);
    }
    throw Exception('Order not found');
  });
}

}
