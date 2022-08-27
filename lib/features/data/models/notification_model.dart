import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.postId,
    required super.data,
    required super.type,
    required super.userId,
    required super.isRead,
  });

  static Map<String, dynamic> toMap({
    required String postId,
    required Map<String, dynamic>? data,
    required NotificationType type,
    required String userId,
  }) {
    return {
      "postId": postId,
      "data": data,
      "type": type.name,
      "userId": userId,
      "isRead": false,
    };
  }
}
