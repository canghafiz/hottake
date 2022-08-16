import 'dart:async';

import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  // function
  @override
  Future<void> addComment({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    await remoteDataSource.addComment(
      postId: postId,
      userId: userId,
      comment: comment,
    );
  }

  @override
  Future<void> addSubComment({
    required String postId,
    required String commentId,
    required String userId,
    required String comment,
  }) async {
    await remoteDataSource.addSubComment(
      postId: postId,
      commentId: commentId,
      userId: userId,
      comment: comment,
    );
  }

  @override
  Future<void> updateFavoriteComment({
    required String postId,
    required String commentId,
    required String userId,
    required bool isAdd,
  }) async {
    await remoteDataSource.updateFavoriteComment(
      postId: postId,
      commentId: commentId,
      userId: userId,
      isAdd: isAdd,
    );
  }

  @override
  FutureOr<void> updateFavoriteSubComment({
    required String postId,
    required String commentId,
    required String subCommentId,
    required String userId,
    required bool isAdd,
  }) async {
    await remoteDataSource.updateFavoriteSubComment(
      postId: postId,
      commentId: commentId,
      subCommentId: subCommentId,
      userId: userId,
      isAdd: isAdd,
    );
  }
}
