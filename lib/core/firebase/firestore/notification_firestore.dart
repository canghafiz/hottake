import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';

class NotificationFirestore {
  Stream<QuerySnapshot> getNotifications(String userId) {
    return Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .collection(Firestore.notificationCollection)
        .snapshots();
  }
}
