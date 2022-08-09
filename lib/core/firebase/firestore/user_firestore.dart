import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';

class UserFirestore {
  Stream<DocumentSnapshot> getRealTimeUser(String userId) {
    return Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .snapshots();
  }

  Future<DocumentSnapshot> getOneTimeUser(String userId) {
    return Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .get();
  }

  Future<QuerySnapshot> getOneTimeUsers() {
    return Firestore.instance.collection(Firestore.userCollection).get();
  }

  Future<void> checkIsUserAvailable({
    required String userId,
    required Function not,
  }) async {
    await getOneTimeUsers().then(
      (query) {
        List check = query.docs.where((doc) => doc.id == userId).toList();

        if (check.isEmpty) {
          not.call();
        }
      },
    );
  }

  Future<void> checkUsername({
    required String username,
    required Function valid,
    required Function notValid,
  }) async {
    await getOneTimeUsers().then(
      (query) {
        List check = query.docs.where((doc) {
          // Model
          final UserEntity user =
              UserEntity.fromMap(doc.data() as Map<String, dynamic>);

          return user.username == username;
        }).toList();

        if (check.isEmpty) {
          valid.call();
        } else {
          notValid.call();
        }
      },
    );
  }

  Future<void> updateTheme({
    required String userId,
    required Function(ThemeEntity) updateTheme,
  }) async {
    await getOneTimeUser(userId).then(
      (doc) {
        // Model
        final UserEntity user =
            UserEntity.fromMap(doc.data() as Map<String, dynamic>);
        final ThemeEntity theme = ThemeEntity.fromMap(user.theme);

        // Update State
        updateTheme.call(theme);
      },
    );
  }

  // Update Data
  Future<void> updateData({
    required String userId,
    required String username,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
    required BuildContext context,
  }) async {
    await dI<UserUpdateData>().call(
      userId: userId,
      username: username,
      bio: bio,
      socialMedia: socialMedia,
      theme: theme,
    );

    Navigator.pop(context);

    // Show Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Your data is updated",
          style: fontStyle(
            size: 13,
            theme: theme,
            color: convertTheme(theme.primary),
          ),
        ),
        backgroundColor: convertTheme(theme.third),
      ),
    );
  }
}
