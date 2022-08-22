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

  Future<void> updateLike({
    required String postId,
    required String userId,
    required bool isAdd,
  });

  Future<void> updateUnLike({
    required String postId,
    required String userId,
    required bool isAdd,
  });

  Future<void> updateRead({
    required String postId,
    required String userId,
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

    // Comment
    await Firestore.instance
        .collection(
          Firestore.postCollection,
        )
        .doc(postId)
        .collection(Firestore.commentCollection)
        .get()
        .then(
      (query) async {
        if (query.docs.isNotEmpty) {
          for (DocumentSnapshot doc in query.docs) {
            // SubComment
            await Firestore.instance
                .collection(
                  Firestore.postCollection,
                )
                .doc(postId)
                .collection(Firestore.commentCollection)
                .doc(doc.id)
                .collection(Firestore.commentCollection)
                .get()
                .then(
              (query) async {
                if (query.docs.isNotEmpty) {
                  for (DocumentSnapshot doc in query.docs) {
                    // Delete Subcomment
                    await Firestore.instance
                        .collection(
                          Firestore.postCollection,
                        )
                        .doc(postId)
                        .collection(Firestore.commentCollection)
                        .doc(doc.id)
                        .collection(Firestore.commentCollection)
                        .doc(doc.id)
                        .delete();
                  }
                }
              },
            );

            // Dlete Comment
            await Firestore.instance
                .collection(
                  Firestore.postCollection,
                )
                .doc(postId)
                .collection(Firestore.commentCollection)
                .doc(doc.id)
                .delete();
          }
        }
      },
    );
  }

  @override
  Future<void> updateLike({
    required String postId,
    required String userId,
    required bool isAdd,
  }) async {
    await Firestore.instance
        .collection(
          Firestore.postCollection,
        )
        .doc(postId)
        .update({
      "likes": isAdd
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId]),
      "unLikes": FieldValue.arrayRemove([userId]),
    });

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

          transaction.update(
            documentReference,
            {
              "totalUnLikes": post.unlikes.length,
              "totalLikes": post.likes.length
            },
          );
        }
      },
    );
  }

  @override
  Future<void> updateUnLike({
    required String postId,
    required String userId,
    required bool isAdd,
  }) async {
    await Firestore.instance
        .collection(
          Firestore.postCollection,
        )
        .doc(postId)
        .update({
      "unLikes": isAdd
          ? FieldValue.arrayUnion([userId])
          : FieldValue.arrayRemove([userId]),
      "likes": FieldValue.arrayRemove([userId]),
    });

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

          transaction.update(
            documentReference,
            {
              "totalUnLikes": post.unlikes.length,
              "totalLikes": post.likes.length,
            },
          );
        }
      },
    );
  }

  @override
  Future<void> updateRead({
    required String postId,
    required String userId,
  }) async {
    await Firestore.instance
        .collection(
          Firestore.postCollection,
        )
        .doc(postId)
        .update({
      "reads": FieldValue.arrayUnion([userId])
    });
  }
}
