import 'dart:async';

import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class CreateNotification {
  final NotificationRepository repository;

  CreateNotification(this.repository);

  FutureOr<void> call({
    required String postId,
    required Map<String, dynamic>? data,
    required NotificationType type,
    required String userId,
    required String myId,
  }) {
    repository.create(
      postId: postId,
      data: data,
      type: type,
      userId: userId,
      myId: myId,
    );
  }
}

class UpdateReadNotification {
  final NotificationRepository repository;

  UpdateReadNotification(this.repository);

  FutureOr<void> call({
    required String userId,
    required String notificationId,
  }) {
    repository.updateRead(userId: userId, notificationId: notificationId);
  }
}

class DeleteNotification {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  FutureOr<void> call({
    required String userId,
    required String notificationId,
  }) {
    repository.delete(userId: userId, notificationId: notificationId);
  }
}

class DeleteAllNotification {
  final NotificationRepository repository;

  DeleteAllNotification(this.repository);

  FutureOr<void> call(String userId) {
    repository.deleteAll(userId);
  }
}
