import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

abstract class UserRemoteDataSource {
  Future<void> createAccount({
    required String userId,
    required String email,
    required String username,
    required String? photo,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  });

  Future<void> updateData({
    required String userId,
    required String username,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  });

  Future<void> updatePhoto({
    required String userId,
    required String? url,
  });
}

class UserRemoteDataSourceFirebase implements UserRemoteDataSource {
  @override
  Future<void> createAccount({
    required String userId,
    required String email,
    required String username,
    required String? photo,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .set(
          UserModel.toMap(
            email: email,
            username: username,
            photo: photo,
            bio: bio,
            socialMedia: socialMedia,
            theme: theme,
          ),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> updateData({
    required String userId,
    required String username,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  }) async {
    await Firestore.instance
        .collection(Firestore.userCollection)
        .doc(userId)
        .set(
      {
        "username": username,
        "bio": bio,
        "socialMedia": socialMedia,
        "theme": theme,
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
        .update({"photo": url});
  }
}
