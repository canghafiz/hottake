import 'package:hottake/core/core.dart';

class NotificationEntity {
  final String userId, type, date;
  final String? postId, comment;
  final bool isRead;

  NotificationEntity({
    required this.postId,
    required this.type,
    required this.userId,
    required this.isRead,
    required this.comment,
    required this.date,
  });

  static NotificationEntity fromMap(Map<String, dynamic> data) {
    return NotificationEntity(
      postId: data['postId'],
      type: data['type'],
      userId: data['userId'],
      isRead: data['isRead'],
      comment: data['comment'],
      date: data['date'],
    );
  }

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
