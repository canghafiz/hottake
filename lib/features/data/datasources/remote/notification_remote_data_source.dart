import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/data/data.dart';

abstract class NotificationRemoteDataSource {
  Future<void> create({
    required String? postId,
    required String? comment,
    required NotificationType type,
    required String userId,
    required String myId,
  });

  Future<void> updateRead({
    required String userId,
    required String notificationId,
  });

  Future<void> delete({
    required String userId,
    required String notificationId,
  });

  Future<void> deleteAll(String userId);
}

class NotificationRemoteDataSourceFirebase
    implements NotificationRemoteDataSource {
  @override
  Future<void> create({
    required String? postId,
    required String? comment,
    required NotificationType type,
    required String userId,
    required String myId,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .collection(Firestore.notificationCollection)
        .add(
          NotificationModel.toMap(
            postId: postId,
            type: type,
            userId: myId,
            comment: comment,
          ),
        );
  }

  @override
  Future<void> updateRead({
    required String userId,
    required String notificationId,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .collection(Firestore.notificationCollection)
        .doc(notificationId)
        .update({
      "isRead": true,
    });
  }

  @override
  Future<void> delete({
    required String userId,
    required String notificationId,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .collection(Firestore.notificationCollection)
        .doc(notificationId)
        .delete();
  }

  @override
  Future<void> deleteAll(String userId) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .collection(Firestore.notificationCollection)
        .get()
        .then(
      (query) {
        for (DocumentSnapshot doc in query.docs) {
          delete(userId: userId, notificationId: doc.id);
        }
      },
    );
  }
}
