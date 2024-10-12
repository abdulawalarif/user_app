import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/core/models/user_model.dart';

class UserDataProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel _userData =  UserModel();
  UserModel get userData => _userData;

  set userData(UserModel value) {
    _userData = value;
    notifyListeners();
  }

  Future<UserModel> fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      if (!user.isAnonymous) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get()
            .then(
                (snapshot) => _userData = UserModel.fromJson(snapshot.data()!))
            .catchError((e) {
          print(e.toString());
        });
      }
      notifyListeners();
      return _userData;
    }
    return UserModel();
  }

  Future<void> uploadUserData(UserModel userModel) async {
    // set user id
    final user = _auth.currentUser;
    userModel.id = user!.uid;

    //set date
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate = "${dateparse.day}-${dateparse.month}-${dateparse.year}";
    userModel.joinedAt = formattedDate;
    userModel.createdAt = Timestamp.now();

    // Upload user data to firebase firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.id)
        .set(userModel.toJson());
    notifyListeners();
  }
  Future<void> updateUserData(UserModel userModel) async {
    // set user id
    final user = _auth.currentUser;
    userModel.id = user!.uid;
    // Upload user data to firebase firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.id)
        .update(userModel.toJson());
    notifyListeners();
  }
}
