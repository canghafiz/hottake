import 'package:hottake/core/core.dart';

class NotificationEntity {
  final String userId, postId, type;
  final Map<String, dynamic>? data;
  final bool isRead;

  NotificationEntity({
    required this.postId,
    required this.data,
    required this.type,
    required this.userId,
    required this.isRead,
  });

  static NotificationEntity fromMap(Map<String, dynamic> data) {
    return NotificationEntity(
      postId: data['postId'],
      data: data['data'],
      type: data['type'],
      userId: data['userId'],
      isRead: data['isRead'],
    );
  }

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

class NotificationCommentDataEntity {
  final String commentId, comment;
  final String? subcommentId;

  NotificationCommentDataEntity({
    required this.comment,
    required this.commentId,
    required this.subcommentId,
  });

  // Map
  static NotificationCommentDataEntity fromMap(Map<String, dynamic> data) {
    return NotificationCommentDataEntity(
      comment: data['comment'],
      commentId: data['commentId'],
      subcommentId: data['subcommentId'],
    );
  }

  static Map<String, dynamic> toMap({
    required String commentId,
    required String comment,
    required String? subcommentId,
  }) {
    return {
      "comment": comment,
      "commentId": commentId,
      "subcommentId": subcommentId,
    };
  }
}
