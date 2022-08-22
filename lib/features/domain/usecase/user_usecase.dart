import 'dart:async';

import 'package:hottake/features/domain/domain.dart';

class UserUpdateData {
  final UserRepository repository;

  UserUpdateData(this.repository);

  FutureOr<void> call({
    required String userId,
    required String email,
    required String username,
    required String? bio,
    required String? socialMedia,
    required double gender,
    required ThemeEntity theme,
  }) {
    repository.updateData(
      email: email,
      userId: userId,
      username: username,
      bio: bio,
      socialMedia: socialMedia,
      gender: gender,
      theme: theme,
    );
  }
}

class UserUpdatePhoto {
  final UserRepository repository;

  UserUpdatePhoto(this.repository);

  FutureOr<void> call({
    required String userId,
    required String? url,
  }) {
    repository.updatePhoto(userId: userId, url: url);
  }
}

class UserUpdateTheme {
  final UserRepository repository;

  UserUpdateTheme(this.repository);

  FutureOr<void> call({
    required String userId,
    required ThemeEntity theme,
  }) {
    repository.updateTheme(userId: userId, theme: theme);
  }
}
