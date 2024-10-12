import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:user_app/core/models/user_model.dart';
import 'package:user_app/core/providers/user_data_provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  bool get isLoggedIn =>
      _auth.currentUser != null && !_auth.currentUser!.isAnonymous;

  Future<void> signUp(
      {required String email,
      required String password,
      required UserModel userModel}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // upload user image to firebase storage and get the url
    if (userModel.imageUrl.isNotEmpty) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('userimages')

          ///from here i can get the user image location for showing on app
          .child(userModel.id + '.jpg');
      await ref
          .putFile(File(userModel.imageUrl))
          .then((_) async => ref.getDownloadURL())
          .then((imageUrl) => userModel.imageUrl = imageUrl)
          .catchError((e) {
        print(e.toString());
      });
    }
    await UserDataProvider().uploadUserData(userModel);
    notifyListeners();
  }

  Future<void> signInAnonymously() async {
    // if (_auth.currentUser == null)
    //   await _auth.signInAnonymously().catchError((e) {
    //     print(e.toString());
    //   });
  }

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  // Google sign in
  Future<void> googleSignIn() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          UserModel userModel = new UserModel(
            id: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? '',
            imageUrl: user.photoURL ?? '',
            phoneNumber: user.phoneNumber ?? '',
          );

          await UserDataProvider()
              .uploadUserData(userModel)
              .then((_) => print('Done Uploading'));
          notifyListeners();
        }
      }
    }
  }

  //Reset Password
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Check if it's not on web app
      if (!kIsWeb) {
        // Check if user is signed in with google sign in
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.disconnect();
        }
      }
      await _auth.signOut().then((_) {
        signInAnonymously();
        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
