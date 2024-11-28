import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWithGoogleFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final _googleSignIn = GoogleSignIn();

  Future<void> googleSignIn() async {
    final googleAccount = await _googleSignIn.signIn();

    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          // Checking if this user already exists on firebase
          if (!userDoc.exists) {
            UserModel userModel = UserModel(
              id: user.uid,
              email: user.email!,
              fullName: user.displayName!,
              imageUrl: user.photoURL!,
              phoneNumber: user.phoneNumber!,
            );

            // Upload user data only if the document doesn't exist
            await uploadUserData(userModel);
            print('User Data is uploaded');
          } else {
            print('User already exists. No need to upload data.');
          }
        }
      }
    }
  }

  Future<void> uploadUserData(UserModel userModel) async {
    try {
      var date = DateTime.now().toString();
      var dateparse = DateTime.parse(date);
      var formattedDate =
          '${dateparse.day}-${dateparse.month}-${dateparse.year}';
      userModel.joinedAt = formattedDate;
      userModel.createdAt = Timestamp.now();
      await _fireStore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class UserModel {
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
        fullName = json['fullName'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        imageUrl = json['imageUrl'],
        address = json['address'],
        joinedAt = json['joinedAt'],
        createdAt = json['createdAt'];

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
