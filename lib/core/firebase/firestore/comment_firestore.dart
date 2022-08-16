import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';

class CommentFirestore {
  Stream<QuerySnapshot> getComments(String postId) {
    return Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .collection(Firestore.commentCollection)
        .orderBy(
          "totalFavorites",
          descending: true,
        )
        .snapshots();
  }
}
