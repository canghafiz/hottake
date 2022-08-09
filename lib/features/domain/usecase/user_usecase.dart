import 'dart:async';

import 'package:hottake/features/domain/domain.dart';

class UserCreateAccount {
  final UserRepository repository;

  UserCreateAccount(this.repository);

  FutureOr<void> call({
    required String userId,
    required String email,
    required String username,
    required String? photo,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  }) {
    repository.createAccount(
      userId: userId,
      email: email,
      username: username,
      photo: photo,
      bio: bio,
      socialMedia: socialMedia,
      theme: theme,
    );
  }
}

class UserUpdateData {
  final UserRepository repository;

  UserUpdateData(this.repository);

  FutureOr<void> call({
    required String userId,
    required String username,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  }) {
    repository.updateData(
      userId: userId,
      username: username,
      bio: bio,
      socialMedia: socialMedia,
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
