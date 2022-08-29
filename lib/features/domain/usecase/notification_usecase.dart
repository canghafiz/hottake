import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class CreateNotification {
  final NotificationRepository repository;

  CreateNotification(this.repository);

  FutureOr<void> call({
    required String? postId,
    required String? comment,
    required NotificationType type,
    required String userId,
    required String myId,
  }) {
    repository.create(
      postId: postId,
      comment: comment,
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

  FutureOr<void> call({
    required String userId,
    required BuildContext context,
  }) {
    // Show Dialog
    showDialog(
      context: context,
      builder: (context) => alertDialogTextWith2Button(
        text: "Are you sure delete all notification",
        fontSize: 13,
        fontColor:
            convertTheme(dI<ThemeCubitEvent>().read(context).state.secondary),
        onfalse: () {
          Navigator.pop(context);
        },
        onTrue: () {
          repository.deleteAll(userId);

          Navigator.pop(context);
        },
        onFalseText: "No",
        onTrueText: "Yes",
      ),
    );
  }
}
