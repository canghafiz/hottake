import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

abstract class PostRemoteDataSource {
  Future<void> createPost({
    required String userId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  });

  Future<void> updatePost({
    required String postId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  });

  Future<void> updateFavorite({
    required String postId,
    required String userId,
    required bool isAdd,
  });

  Future<void> deletePost(String postId);
}

class PostRemoteDataSourceFirebase implements PostRemoteDataSource {
  @override
  Future<void> createPost({
    required String userId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  }) async {
    await Firestore.instance
        .collection(
          Firestore.postCollection,
        )
        .add(
          PostModel.toMap(
            userId: userId,
            longitude: longitude,
            latitude: latitude,
            note: note,
            userPoll: userPoll,
            rating: rating,
          ),
        );
  }

  @override
  Future<void> updatePost({
    required String postId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  }) async {
    await Firestore.instance
        .collection(
          Firestore.postCollection,
        )
        .doc(postId)
        .update({
      "longitude": longitude,
      "latitude": latitude,
      "note": note,
      "userPoll": userPoll,
      "rating": rating,
    });
  }

  @override
  Future<void> updateFavorite({
    required String postId,
    required String userId,
    required bool isAdd,
  }) async {
    if (isAdd) {
      await Firestore.instance
          .collection(
            Firestore.postCollection,
          )
          .doc(postId)
          .update({
        "favorites": FieldValue.arrayUnion([userId]),
      });
    } else {
      await Firestore.instance
          .collection(
            Firestore.postCollection,
          )
          .doc(postId)
          .update({
        "favorites": FieldValue.arrayRemove([userId]),
      });
    }

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

          int newFavoritesCount = isAdd
              ? post.totalFavorites + 1
              : (post.totalFavorites < 1)
                  ? 0
                  : post.totalFavorites - 1;

          transaction.update(
            documentReference,
            {"totalFavorites": newFavoritesCount},
          );
        }
      },
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    await Firestore.instance
        .collection(
          Firestore.postCollection,
        )
        .doc(postId)
        .delete();
  }
}
