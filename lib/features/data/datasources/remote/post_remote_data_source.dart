import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/data/data.dart';

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
