import 'package:hottake/core/core.dart';
import 'dart:async';

import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> create({
    required String postId,
    required Map<String, dynamic>? data,
    required NotificationType type,
    required String userId,
    required String myId,
  }) async {
    remoteDataSource.create(
      postId: postId,
      data: data,
      type: type,
      userId: userId,
      myId: myId,
    );
  }

  @override
  FutureOr<void> updateRead({
    required String userId,
    required String notificationId,
  }) async {
    remoteDataSource.updateRead(userId: userId, notificationId: notificationId);
  }

  @override
  Future<void> delete({
    required String userId,
    required String notificationId,
  }) async {
    remoteDataSource.delete(userId: userId, notificationId: notificationId);
  }

  @override
  Future<void> deleteAll(String userId) async {
    remoteDataSource.deleteAll(userId);
  }
}
