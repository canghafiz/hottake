import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/cubits/navbar/navbar_cubit.dart';

class PostFirestore {
  Future<DocumentSnapshot> getSinglePost(String postId) {
    return Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .get();
  }

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

  Future<void> afterFromPostCreator({
    required String userId,
    required ThemeEntity theme,
    required User user,
    required BuildContext context,
  }) async {
    await Firestore.instance
        .collection(Firestore.postCollection)
        .orderBy("dateCreated", descending: true)
        .get()
        .then(
      (query) {
        // Navigate
        toMainPage(
          context: context,
          postId: query.docs[0].id,
        );

        // Update State
        dI<NavbarCubitEvent>().read(context).updateBottom(1);
      },
    );
  }
}
