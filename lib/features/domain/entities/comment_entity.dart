import 'package:hottake/core/core.dart';

class CommentEntity {
  final String userId, comments, date;
  final List favorites;
  final int totalFavorites;

  CommentEntity({
    required this.comments,
    required this.date,
    required this.favorites,
    required this.userId,
    required this.totalFavorites,
  });

  // Map
  static CommentEntity fromMap(Map<String, dynamic> data) {
    return CommentEntity(
      comments: data['comment'],
      date: data['date'],
      favorites: data['favorites'],
      userId: data['userId'],
      totalFavorites: data['totalFavorites'],
    );
  }

  static Map<String, dynamic> toMap({
    required String userId,
    required String comment,
  }) {
    return {
      "userId": userId,
      "comment": comment,
      "favorites": [],
      "totalFavorites": 0,
      "date": convertTime(DateTime.now()),
    };
  }
}
