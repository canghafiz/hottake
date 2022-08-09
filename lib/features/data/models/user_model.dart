import 'package:hottake/features/domain/domain.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.bio,
    required super.email,
    required super.photo,
    required super.socialMedia,
    required super.theme,
    required super.username,
  });

  // Map
  static UserModel fromMap(Map<String, dynamic> data) {
    return UserModel(
      bio: data['bio'],
      email: data['email'],
      photo: data['photo'],
      socialMedia: data['socialMedia'],
      theme: data['theme'],
      username: data['username'],
    );
  }

  static Map<String, dynamic> toMap({
    required String email,
    required String username,
    required String? photo,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  }) {
    return {
      "email": email,
      "username": username,
      "photo": photo,
      "bio": bio,
      "socialMedia": socialMedia,
      "theme": ThemeEntity.toMap(
        primary: theme.primary,
        secondary: theme.secondary,
        third: theme.third,
      ),
    };
  }
}
