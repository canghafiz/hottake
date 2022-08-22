import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

abstract class UserRemoteDataSource {
  Future<void> updateData({
    required String userId,
    required String email,
    required String username,
    required String? bio,
    required String? socialMedia,
    required double gender,
    required ThemeEntity theme,
  });

  Future<void> updatePhoto({
    required String userId,
    required String? url,
  });

  Future<void> updateTheme({
    required String userId,
    required ThemeEntity theme,
  });
}

class UserRemoteDataSourceFirebase implements UserRemoteDataSource {
  @override
  Future<void> updateData({
    required String userId,
    required String email,
    required String username,
    required String? bio,
    required String? socialMedia,
    required double gender,
    required ThemeEntity theme,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .set(
      {
        "email": email,
        "username": username,
        "bio": bio,
        "socialMedia": socialMedia,
        "gender": gender,
        "theme": ThemeEntity.toMap(
          primary: theme.primary,
          secondary: theme.secondary,
          third: theme.third,
        ),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> updatePhoto({
    required String userId,
    required String? url,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .set(
      {"photo": url},
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> updateTheme({
    required String userId,
    required ThemeEntity theme,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .set(
      {
        "theme": ThemeEntity.toMap(
          primary: theme.primary,
          secondary: theme.secondary,
          third: theme.third,
        ),
      },
      SetOptions(merge: true),
    );
  }
}
