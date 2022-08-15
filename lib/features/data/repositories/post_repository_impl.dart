import 'dart:async';

import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createPost({
    required String userId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  }) async {
    await remoteDataSource.createPost(
      userId: userId,
      longitude: longitude,
      latitude: latitude,
      note: note,
      userPoll: userPoll,
      rating: rating,
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
    await remoteDataSource.updatePost(
      postId: postId,
      longitude: longitude,
      latitude: latitude,
      note: note,
      userPoll: userPoll,
      rating: rating,
    );
  }

  @override
  Future<void> updateFavorite({
    required String postId,
    required String userId,
    required bool isAdd,
  }) async {
    await remoteDataSource.updateFavorite(
      postId: postId,
      userId: userId,
      isAdd: isAdd,
    );
  }

  @override
  Future<void> deletePost(String postId) async {
    await remoteDataSource.deletePost(postId);
  }
}
