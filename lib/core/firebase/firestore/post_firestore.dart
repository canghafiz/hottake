import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';

class PostFirestore {
  Stream<QuerySnapshot> getMyNoteRealtime(String userId) {
    return Firestore.instance
        .collection(Firestore.postCollection)
        .where("userId", isEqualTo: userId)
        .orderBy("totalFavorites", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getNotes() {
    return Firestore.instance.collection(Firestore.postCollection).snapshots();
  }

  Stream<QuerySnapshot> getFavoriteNotes(String userId) {
    return Firestore.instance
        .collection(Firestore.postCollection)
        .where("favorites", arrayContains: [userId]).snapshots();
  }
}
