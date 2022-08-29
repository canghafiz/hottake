import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget({
    Key? key,
    required this.notificationId,
    required this.notification,
    required this.userId,
    required this.theme,
    required this.userAuth,
  }) : super(key: key);
  final String userId, notificationId;
  final NotificationEntity notification;
  final ThemeEntity theme;
  final User userAuth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: dI<UserFirestore>().getOneTimeUser(notification.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        // Model
        final UserEntity user =
            UserEntity.fromMap(snapshot.data!.data() as Map<String, dynamic>);
        final titleDefine = (notification.type == NotificationType.comment.name)
            ? "comment on your post"
            : "${(NotificationType.values.firstWhere((element) => element.name == notification.type) == NotificationType.like) ? "upvote" : "favorite"} your post";

        return ListTile(
          onTap: () {
            // Update Data
            dI<UpdateReadNotification>().call(
              userId: userId,
              notificationId: notificationId,
            );

            // Navigate
            if (notification.type == NotificationType.comment.name) {
              toCommentsPage(
                context: context,
                userId: userId,
                postId: notification.postId!,
                user: userAuth,
              );
              return;
            }

            toMapPage(
              context: context,
              userId: userId,
              postId: notification.postId,
              user: userAuth,
            );
          },
          leading: PhotoProfileWidget(
            url: user.photo,
            size: 18,
            theme: theme,
          ),
          title: Text(
            "@${user.username} $titleDefine",
            style: fontStyle(
              size: 11,
              theme: theme,
              weight: FontWeight.bold,
              color: convertTheme(theme.secondary)
                  .withOpacity(notification.isRead ? 0.5 : 1),
            ),
          ),
          subtitle: (notification.comment != null)
              ? Text(
                  "${notification.comment!}\n\n${timeDuration(notification.date)}",
                  style: fontStyle(
                    size: 11,
                    theme: theme,
                    color: convertTheme(theme.secondary)
                        .withOpacity(notification.isRead ? 0.5 : 1),
                  ),
                )
              : Text(
                  timeDuration(notification.date),
                  style: fontStyle(
                    size: 11,
                    theme: theme,
                    color: convertTheme(theme.secondary)
                        .withOpacity(notification.isRead ? 0.5 : 1),
                  ),
                ),
        );
      },
    );
  }
}
