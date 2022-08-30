import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class NotificationService {
  static final _instance = FirebaseMessaging.instance;
  final _serverKey =
      "AAAAAs5zSYs:APA91bGJFtav68I_gr82v7UFF_gyS8vJc0XqXrVrbEOD8IOgotVbr1VyFRfceYTnih1BS0Kia547Q6gBTQdPOkEQ7Vb4VU92ZW2xBPVY-BKIgQOal8kJiXNiGct0RrosbVtnfzF0HEAl";

  // Public Function
  void subAllTopics(String userId) {
    _subPostTopic(userId);
  }

  void unsubAllTopic(String userId) {
    _unsubPostTopic(userId);
  }

  Future<void> setupMessageHandling(User user) async {
    await _onMessage(user);
  }

  Future<void> sendNotifPost({
    required String? postId,
    required String? comment,
    required NotificationType type,
    required String userId,
    required String myId,
    required String username,
  }) async {
    if (myId != userId) {
      final String title = (type == NotificationType.comment)
          ? "comment on your post"
          : "${(type == NotificationType.like) ? "upvote" : "favorite"} your post";
      _sendNotification(
        title: (comment == null) ? "Post" : "$username $title",
        subject: (comment != null) ? comment : "$username $title",
        topics: "${userId}Post",
        postId: postId,
        comment: comment,
        type: type,
        userId: userId,
      ).then(
        (success) {
          if (success) {
            // Update Data
            dI<CreateNotification>().call(
              postId: postId,
              comment: comment,
              type: type,
              userId: userId,
              myId: myId,
            );
          }
        },
      );
    }
  }

  // Private Function
  void _subPostTopic(String userId) {
    _instance.subscribeToTopic("${userId}Post");
  }

  void _unsubPostTopic(String userId) {
    _instance.unsubscribeFromTopic("${userId}Post");
  }

  Future<bool> _sendNotification({
    required String title,
    required String subject,
    required String topics,
    required String? postId,
    required String? comment,
    required NotificationType type,
    required String userId,
  }) async {
    var postUrl = 'https://fcm.googleapis.com/fcm/send';

    String toParams = "/topics/$topics";

    final data = {
      "notification": {"body": subject, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "status": "done",
        "sound": 'default',
        "postId": postId ?? "null",
        "type": type.name,
        "userId": userId,
      },
      "to": toParams,
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': "key=$_serverKey",
    };

    final response = await http.post(
      Uri.tryParse(postUrl)!,
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // on success do
      debugPrint("Success send notif to $topics");
      return true;
    } else {
      // on failure do
      debugPrint("Failed send notif to $topics");
      return false;
    }
  }

  Future<void> _onMessage(User user) async {
    FirebaseMessaging.onMessage.listen(
      (message) {
        // Define Message
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification!.android;

        if (notification != null && android != null) {
          // When notif on click
          _notifSetting(
            notifPlugin: flutterLocalNotificationsPlugin,
            postId: (message.data['postId'] == "null")
                ? null
                : message.data['postId'],
            type: NotificationType.values
                .firstWhere((element) => element.name == message.data['type']),
            userId: message.data['userId'],
            user: user,
          );

          // Call Notif Structure
          _notifStructure(notification);
        }
      },
    );
  }

  void _notifStructure(RemoteNotification notification) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel id 0",
          "channel name",
          icon: "@mipmap/ic_launcher",
          priority: Priority.high,
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails(),
      ),
    );
  }

  void _notifSetting({
    required FlutterLocalNotificationsPlugin notifPlugin,
    required String? postId,
    required NotificationType type,
    required String userId,
    required User user,
  }) {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = const IOSInitializationSettings();

    notifPlugin.initialize(
      InitializationSettings(android: android, iOS: ios),
      onSelectNotification: (_) async {
        // Post
        if (postId != null) {
          // Comment
          if (type == NotificationType.comment) {
            // Navigate
            navigatorKey.currentState!.push(
              route(
                CommentsPage(
                  postId: postId,
                  userId: userId,
                  user: user,
                ),
              ),
            );
          }
          // Favorite & Like
          if (type == NotificationType.favorite ||
              type == NotificationType.like) {
            // Navigate
            navigatorKey.currentState!.push(
              route(
                MapPage(
                  userId: userId,
                  postId: postId,
                  user: user,
                  fromMainPage: false,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
