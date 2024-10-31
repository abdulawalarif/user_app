import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addSingleOrderToDatabase(
      {required OrdersModel ordersModel}) async {
    // set user id
    final user = _auth.currentUser;

    //set date
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = '${dateparse.day}-${dateparse.month}-${dateparse.year}';
    ordersModel.orderDate = formattedDate;

    // Upload user data to firebase firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(date + user!.uid)
        .set(ordersModel.toJson());
    notifyListeners();
  }

  Future<void> addListOfOrdersToDatabase(
      {required List<OrdersModel> orderList}) async {}
}

/// TODO will have to add a different mechanism for orders commming from cart with multiple items
