import 'package:hottake/features/domain/domain.dart';

class UserEntity {
  final String email, username;
  final String? photo, bio, socialMedia;
  final Map<String, dynamic> theme;
  final double gender;

  UserEntity({
    required this.bio,
    required this.email,
    required this.photo,
    required this.socialMedia,
    required this.theme,
    required this.username,
    required this.gender,
  });

  // Map
  static UserEntity fromMap(Map<String, dynamic> data) {
    return UserEntity(
      bio: data['bio'],
      email: data['email'],
      photo: data['photo'],
      socialMedia: data['socialMedia'],
      theme: data['theme'],
      username: data['username'],
      gender: data['gender'],
    );
  }

  static Map<String, dynamic> toMap({
    required String email,
    required String username,
    required String? photo,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
    required double gender,
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
      "gender": gender,
    };
  }
}
