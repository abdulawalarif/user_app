import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/user_model.dart';
import 'firebase_service.dart';

class UserDataProvider with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FireStoreService().instance;
   UserModel _userData = UserModel();
  UserModel get userData => _userData;

    

  Future<UserModel> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final uid = user.uid;
        if (!user.isAnonymous) {
          final snapshot = await _fireStore.collection('users').doc(uid).get();
          _userData = UserModel.fromJson(snapshot.data()!);
        }
        notifyListeners();
        return _userData;
      }
      return UserModel();
    } catch (e) {
      return UserModel();
    }
  }

  Future<void> uploadUserData(UserModel userModel) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        userModel.id = user.uid;
        var date = DateTime.now().toString();
        var dateparse = DateTime.parse(date);
        var formattedDate =
            '${dateparse.day}-${dateparse.month}-${dateparse.year}';
        userModel.joinedAt = formattedDate;
        userModel.createdAt = Timestamp.now();
        await _fireStore
            .collection('users')
            .doc(userModel.id)
            .set(userModel.toJson())
            .then((_) async {
          await fetchUserData();
          
        });
      } else {
        throw Exception('No authenticated user found');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserData(UserModel userModel) async {
    ///TODO fixing update not changing existing user data of shipping address and so on
    try {
      final user = _auth.currentUser;
      userModel.id = user!.uid;
      await _fireStore
          .collection('users')
          .doc(userModel.id)
          .update(userModel.toJson());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
