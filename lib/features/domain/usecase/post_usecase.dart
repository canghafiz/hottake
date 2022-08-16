import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost(this.repository);

  FutureOr<void> call({
    required String userId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
    required BuildContext context,
  }) {
    repository.createPost(
      userId: userId,
      longitude: longitude,
      latitude: latitude,
      note: note,
      userPoll: userPoll,
      rating: rating,
    );

    // Navigate
    toUserPage(context: context, userId: userId, initialTab: 1);
  }
}

class UpdatePost {
  final PostRepository repository;

  UpdatePost(this.repository);

  FutureOr<void> call({
    required String userId,
    required String postId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
    required BuildContext context,
  }) {
    repository.updatePost(
      postId: postId,
      longitude: longitude,
      latitude: latitude,
      note: note,
      userPoll: userPoll,
      rating: rating,
    );

    // Navigate
    toUserPage(context: context, userId: userId, initialTab: 1);
  }
}

class UpdateFavoritePost {
  final PostRepository repository;

  UpdateFavoritePost(this.repository);

  FutureOr<void> call({
    required String postId,
    required String userId,
    required bool isAdd,
  }) {
    repository.updateFavorite(
      postId: postId,
      userId: userId,
      isAdd: isAdd,
    );
  }
}

class DeletePost {
  final PostRepository repository;

  DeletePost(this.repository);

  FutureOr<void> call(String postId) {
    repository.deletePost(postId);
  }
}
