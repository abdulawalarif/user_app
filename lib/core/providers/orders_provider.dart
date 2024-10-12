import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/orders_model.dart';

class OrdersProvider extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> addOrdersToDatabase({ required OrdersModel ordersModel}) async{
    // set user id
    final user = _auth.currentUser;

    //set date
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    ordersModel.orderDate = formattedDate;

    // Upload user data to firebase firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(date+user!.uid)
        .set(ordersModel.toJson());
    notifyListeners();
  }
}