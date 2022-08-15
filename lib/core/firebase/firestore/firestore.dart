import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  static final instance = FirebaseFirestore.instance;
  static const userCollection = "USER";
  static const postCollection = "POST";
}
