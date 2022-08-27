import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
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
    required User user,
    required ThemeEntity theme,
  }) {
    repository.createPost(
      userId: userId,
      longitude: longitude,
      latitude: latitude,
      note: note,
      userPoll: userPoll,
      rating: rating,
    );

    dI<PostFirestore>().afterFromPostCreator(
      userId: userId,
      theme: theme,
      user: user,
      context: context,
    );
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
    required User user,
    required ThemeEntity theme,
  }) {
    repository.updatePost(
      postId: postId,
      longitude: longitude,
      latitude: latitude,
      note: note,
      userPoll: userPoll,
      rating: rating,
    );

    //  Navigate
    dI<PostFirestore>().afterFromPostCreator(
      userId: userId,
      theme: theme,
      user: user,
      context: context,
    );
  }
}

class UpdateVotePost {
  final PostRepository repository;

  UpdateVotePost(this.repository);

  FutureOr<void> call({
    required String postId,
    required String userId,
    required int optionId,
  }) {
    repository.updateVote(
      postId: postId,
      userId: userId,
      optionId: optionId,
    );
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

class UpdateLikePost {
  final PostRepository repository;

  UpdateLikePost(this.repository);

  FutureOr<void> call({
    required String postId,
    required String userId,
    required bool isAdd,
  }) {
    repository.updateLike(
      postId: postId,
      userId: userId,
      isAdd: isAdd,
    );
  }
}

class UpdateUnLikePost {
  final PostRepository repository;

  UpdateUnLikePost(this.repository);

  FutureOr<void> call({
    required String postId,
    required String userId,
    required bool isAdd,
  }) {
    repository.updateUnLike(
      postId: postId,
      userId: userId,
      isAdd: isAdd,
    );
  }
}

class UpdateReadPost {
  final PostRepository repository;

  UpdateReadPost(this.repository);

  FutureOr<void> call({
    required String postId,
    required String userId,
  }) {
    repository.updateRead(postId: postId, userId: userId);
  }
}

class DeletePost {
  final PostRepository repository;

  DeletePost(this.repository);

  FutureOr<void> call(String postId) {
    repository.deletePost(postId);
  }
}
