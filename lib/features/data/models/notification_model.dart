import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.postId,
    required super.type,
    required super.userId,
    required super.isRead,
    required super.comment,
    required super.date,
  });

  static Map<String, dynamic> toMap({
    required String? postId,
    required String? comment,
    required NotificationType type,
    required String userId,
  }) {
    return {
      "postId": postId,
      "comment": comment,
      "type": type.name,
      "userId": userId,
      "isRead": false,
      "date": convertTime(DateTime.now()),
    };
  }
}
