import 'dart:async';

abstract class PostRepository {
  FutureOr<void> createPost({
    required String userId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  });

  FutureOr<void> updatePost({
    required String postId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  });

  FutureOr<void> updateFavorite({
    required String postId,
    required String userId,
    required bool isAdd,
  });

  FutureOr<void> updateLike({
    required String postId,
    required String userId,
    required bool isAdd,
  });

  FutureOr<void> updateUnLike({
    required String postId,
    required String userId,
    required bool isAdd,
  });

  FutureOr<void> updateRead({
    required String postId,
    required String userId,
  });

  FutureOr<void> deletePost(String postId);
}
