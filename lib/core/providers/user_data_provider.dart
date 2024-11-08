import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/orders_model.dart';
import 'package:user_app/core/models/user_model.dart';

class UserDataProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel _userData = UserModel();
  UserModel get userData => _userData;

  ShippingAddress? _shippingAddress;

  ShippingAddress? get shippingAddress => _shippingAddress;

  set userData(UserModel value) {
    _userData = value;
    notifyListeners();
  }

  Future<UserModel> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final uid = user.uid;
        if (!user.isAnonymous) {
          final snapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          _userData = UserModel.fromJson(snapshot.data()!);
          final data = snapshot.data();
          if (data != null && data['shippingAddress']!=null) {
            final shippingAddress = data['shippingAddress'];
            _shippingAddress = ShippingAddress.fromJson(shippingAddress);
          }
        }
        notifyListeners();
        return _userData;
      }
      return UserModel();
    } catch (e) {
      print('Error fetching user data: ${e.toString()}');
      return UserModel(); // Return a default UserModel in case of error
    }
  }

  Future<void> uploadUserData(UserModel userModel) async {
    try {
      // Set user id
      final user = _auth.currentUser;
      if (user != null) {
        userModel.id = user.uid;

        // Set date
        var date = DateTime.now().toString();
        var dateparse = DateTime.parse(date);
        var formattedDate =
            '${dateparse.day}-${dateparse.month}-${dateparse.year}';
        userModel.joinedAt = formattedDate;
        userModel.createdAt = Timestamp.now();

        // Upload user data to Firebase Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.id)
            .set(userModel.toJson());
        notifyListeners();
      } else {
        throw Exception('No authenticated user found');
      }
    } catch (e) {
      print('Failed to upload user data: $e');
      // Optionally, you can handle the error further, e.g., showing a message to the user
    }
  }

  Future<void> updateUserData(UserModel userModel) async {
    try {
      // Set user ID
      final user = _auth.currentUser;
      userModel.id = user!.uid;

      // Upload user data to Firebase Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toJson());

      notifyListeners();
    } catch (e) {
      // Handle errors here
      print('Failed to update user data: $e');
    }
  }
}
