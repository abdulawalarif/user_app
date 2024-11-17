import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  FireStoreService._();
  static final FireStoreService _instance = FireStoreService._();
  factory FireStoreService() => _instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseFirestore get instance => _fireStore;
}
