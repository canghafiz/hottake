import 'dart:async';

import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  FutureOr<void> createAccount({
    required String userId,
    required String email,
    required String username,
    required String? photo,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  }) {
    remoteDataSource.createAccount(
      userId: userId,
      email: email,
      username: username,
      photo: photo,
      bio: bio,
      socialMedia: socialMedia,
      theme: theme,
    );
  }

  @override
  FutureOr<void> updateData({
    required String userId,
    required String username,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  }) {
    remoteDataSource.updateData(
      userId: userId,
      username: username,
      bio: bio,
      socialMedia: socialMedia,
      theme: theme,
    );
  }

  @override
  FutureOr<void> updatePhoto({
    required String userId,
    required String? url,
  }) {
    remoteDataSource.updatePhoto(userId: userId, url: url);
  }
}
