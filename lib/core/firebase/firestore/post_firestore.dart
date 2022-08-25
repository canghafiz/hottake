import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';

class PostFirestore {
  Stream<QuerySnapshot> getMyNoteRealtime({
    required String userId,
    required PostOrderType type,
  }) {
    switch (type) {
      case PostOrderType.controversial:
        return Firestore.instance
            .collection(Firestore.postCollection)
            .where("userId", isEqualTo: userId)
            .orderBy("totalUnLikes", descending: true)
            .snapshots();

      case PostOrderType.popular:
        return Firestore.instance
            .collection(Firestore.postCollection)
            .where("userId", isEqualTo: userId)
            .orderBy("totalLikes", descending: true)
            .snapshots();

      case PostOrderType.nearest:
        return Firestore.instance
            .collection(Firestore.postCollection)
            .where("userId", isEqualTo: userId)
            .snapshots();

      default:
        return Firestore.instance
            .collection(Firestore.postCollection)
            .where("userId", isEqualTo: userId)
            .orderBy("dateCreated", descending: true)
            .snapshots();
    }
  }

  Stream<QuerySnapshot> getNotes() {
    return Firestore.instance.collection(Firestore.postCollection).snapshots();
  }

  Stream<QuerySnapshot> orderType(PostOrderType type) {
    switch (type) {
      case PostOrderType.controversial:
        return Firestore.instance
            .collection(Firestore.postCollection)
            .orderBy("totalUnLikes", descending: true)
            .snapshots();

      case PostOrderType.popular:
        return Firestore.instance
            .collection(Firestore.postCollection)
            .orderBy("totalLikes", descending: true)
            .snapshots();

      case PostOrderType.nearest:
        return getNotes();

      default:
        return Firestore.instance
            .collection(Firestore.postCollection)
            .orderBy("dateCreated", descending: true)
            .snapshots();
    }
  }

  Stream<DocumentSnapshot> getSingleNoteRealtime(String postId) {
    return Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .snapshots();
  }
}
