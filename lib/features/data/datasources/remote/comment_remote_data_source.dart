import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/core/firebase/firestore/firestore.dart';
import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

abstract class CommentRemoteDataSource {
  Future<void> addComment({
    required String postId,
    required String userId,
    required String comment,
  });

  Future<void> addSubComment({
    required String postId,
    required String commentId,
    required String userId,
    required String comment,
  });

  Future<void> updateFavoriteComment({
    required String postId,
    required String commentId,
    required String userId,
    required bool isAdd,
  });

  Future<void> updateFavoriteSubComment({
    required String postId,
    required String commentId,
    required String subCommentId,
    required String userId,
    required bool isAdd,
  });
}

class CommentRemoteDataSourceFirebase implements CommentRemoteDataSource {
  @override
  Future<void> addComment({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    await Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .collection(Firestore.commentCollection)
        .add(
          CommentModel.toMap(userId: userId, comment: comment),
        );

    // Transaction
    DocumentReference documentReference =
        Firestore.instance.collection(Firestore.postCollection).doc(postId);

    Firestore.instance.runTransaction(
      (transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          // Model
          final PostEntity post =
              PostEntity.fromMap(snapshot.data() as Map<String, dynamic>);

          int newCommentsCount = post.totalComments + 1;

          transaction.update(
            documentReference,
            {"totalComments": newCommentsCount},
          );
        }
      },
    );
  }

  @override
  Future<void> addSubComment({
    required String postId,
    required String commentId,
    required String userId,
    required String comment,
  }) async {
    await Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .collection(Firestore.commentCollection)
        .doc(commentId)
        .collection(Firestore.commentCollection)
        .add(
          CommentModel.toMap(userId: userId, comment: comment),
        );

    // Transaction
    DocumentReference documentReference =
        Firestore.instance.collection(Firestore.postCollection).doc(postId);

    Firestore.instance.runTransaction(
      (transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          // Model
          final PostEntity post =
              PostEntity.fromMap(snapshot.data() as Map<String, dynamic>);

          int newCommentsCount = post.totalComments + 1;

          transaction.update(
            documentReference,
            {"totalComments": newCommentsCount},
          );
        }
      },
    );
  }

  @override
  Future<void> updateFavoriteComment({
    required String postId,
    required String userId,
    required String commentId,
    required bool isAdd,
  }) async {
    await Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .collection(Firestore.commentCollection)
        .doc(commentId)
        .set(
      {
        "favorites": isAdd
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId]),
      },
      SetOptions(merge: true),
    );

    // Transaction
    DocumentReference documentReference = Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .collection(Firestore.commentCollection)
        .doc(commentId);

    Firestore.instance.runTransaction(
      (transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          // Model
          final CommentEntity comment =
              CommentEntity.fromMap(snapshot.data() as Map<String, dynamic>);

          int newFavoritesCount = isAdd
              ? comment.totalFavorites + 1
              : (comment.totalFavorites < 1)
                  ? 0
                  : comment.totalFavorites - 1;

          transaction.set(
            documentReference,
            {"totalFavorites": newFavoritesCount},
            SetOptions(merge: true),
          );
        }
      },
    );
  }

  @override
  Future<void> updateFavoriteSubComment({
    required String postId,
    required String commentId,
    required String subCommentId,
    required String userId,
    required bool isAdd,
  }) async {
    await Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .collection(Firestore.commentCollection)
        .doc(commentId)
        .collection(Firestore.commentCollection)
        .doc(subCommentId)
        .set(
      {
        "favorites": isAdd
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId]),
      },
      SetOptions(merge: true),
    );

    // Transaction
    DocumentReference documentReference = Firestore.instance
        .collection(Firestore.postCollection)
        .doc(postId)
        .collection(Firestore.commentCollection)
        .doc(commentId)
        .collection(Firestore.commentCollection)
        .doc(subCommentId);

    Firestore.instance.runTransaction(
      (transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          // Model
          final CommentEntity comment =
              CommentEntity.fromMap(snapshot.data() as Map<String, dynamic>);

          int newFavoritesCount = isAdd
              ? comment.totalFavorites + 1
              : (comment.totalFavorites < 1)
                  ? 0
                  : comment.totalFavorites - 1;

          transaction.set(
            documentReference,
            {"totalFavorites": newFavoritesCount},
            SetOptions(merge: true),
          );
        }
      },
    );
  }
}
