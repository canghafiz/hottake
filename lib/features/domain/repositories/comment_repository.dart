import 'dart:async';

abstract class CommentRepository {
  FutureOr<void> addComment({
    required String postId,
    required String userId,
    required String comment,
  });

  FutureOr<void> addSubComment({
    required String postId,
    required String commentId,
    required String userId,
    required String comment,
  });

  FutureOr<void> updateFavoriteComment({
    required String postId,
    required String commentId,
    required String userId,
    required bool isAdd,
  });

  FutureOr<void> updateFavoriteSubComment({
    required String postId,
    required String commentId,
    required String subCommentId,
    required String userId,
    required bool isAdd,
  });
}
