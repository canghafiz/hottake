import 'dart:async';

import 'package:hottake/features/data/data.dart';
import 'package:hottake/features/domain/domain.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  FutureOr<void> updateData({
    required String userId,
    required String email,
    required String username,
    required String? bio,
    required String? socialMedia,
    required double gender,
    required ThemeEntity theme,
  }) {
    remoteDataSource.updateData(
      userId: userId,
      email: email,
      username: username,
      bio: bio,
      socialMedia: socialMedia,
      gender: gender,
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

  @override
  FutureOr<void> updateTheme({
    required String userId,
    required ThemeEntity theme,
  }) {
    remoteDataSource.updateTheme(userId: userId, theme: theme);
  }
}
