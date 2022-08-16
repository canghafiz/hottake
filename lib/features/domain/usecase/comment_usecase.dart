import 'dart:async';

import 'package:hottake/features/domain/domain.dart';

class AddComment {
  final CommentRepository repository;

  AddComment(this.repository);

  FutureOr<void> call({
    required String postId,
    required String userId,
    required String comment,
  }) {
    repository.addComment(
      postId: postId,
      userId: userId,
      comment: comment,
    );
  }
}

class AddSubComment {
  final CommentRepository repository;

  AddSubComment(this.repository);

  FutureOr<void> call({
    required String postId,
    required String commentId,
    required String userId,
    required String comment,
  }) {
    repository.addSubComment(
      postId: postId,
      commentId: commentId,
      userId: userId,
      comment: comment,
    );
  }
}

class UpdateFavoriteComment {
  final CommentRepository repository;

  UpdateFavoriteComment(this.repository);

  FutureOr<void> call({
    required String postId,
    required String commentId,
    required String userId,
    required bool isAdd,
  }) {
    repository.updateFavoriteComment(
      postId: postId,
      commentId: commentId,
      userId: userId,
      isAdd: isAdd,
    );
  }
}

class UpdateFavoriteSubComment {
  final CommentRepository repository;

  UpdateFavoriteSubComment(this.repository);

  FutureOr<void> call({
    required String postId,
    required String commentId,
    required String subCommentId,
    required String userId,
    required bool isAdd,
  }) {
    repository.updateFavoriteSubComment(
      postId: postId,
      commentId: commentId,
      subCommentId: subCommentId,
      userId: userId,
      isAdd: isAdd,
    );
  }
}
