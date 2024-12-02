import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String id;
  String fullName;
  String imageUrl;
  String address;
  String phoneNumber;
  String email;
  String joinedAt;
  Timestamp? createdAt;

  UserModel({
    this.id = '',
    this.fullName = '',
    this.address = '',
    this.phoneNumber = '',
    this.imageUrl = '',
    this.email = '',
    this.joinedAt = '',
    this.createdAt,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName']??"",
        email = json['email']??"",
        phoneNumber = json['phoneNumber']??"",
        imageUrl = json['imageUrl']??"",
        address = json['address']??"",
        joinedAt = json['joinedAt']??"",
        createdAt = json['createdAt']??"";

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
        'address': address,
        'joinedAt': joinedAt,
        'createdAt': createdAt,
      };
}
/// await _fireStore.collection('users').doc(order.customerId).set(
      //   {
      //     'shippingAddress':
      //         shippingAddress.toJson(), // Storing address under users ID
      //     'orders': FieldValue.arrayUnion([orderId]),
      //   },
      //   SetOptions(merge: true),
      // );