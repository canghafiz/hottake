import 'dart:async';

import 'package:hottake/core/core.dart';

abstract class NotificationRepository {
  FutureOr<void> create({
    required String postId,
    required Map<String, dynamic>? data,
    required NotificationType type,
    required String userId,
    required String myId,
  });

  FutureOr<void> updateRead({
    required String userId,
    required String notificationId,
  });

  FutureOr<void> delete({
    required String userId,
    required String notificationId,
  });

  FutureOr<void> deleteAll(String userId);
}
