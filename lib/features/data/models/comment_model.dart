import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required super.comments,
    required super.date,
    required super.favorites,
    required super.userId,
    required super.totalFavorites,
  });

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
