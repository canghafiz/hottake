import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class PostModel extends PostEntity {
  PostModel({
    required super.dateCreated,
    required super.favorites,
    required super.latitude,
    required super.longitude,
    required super.note,
    required super.rating,
    required super.userId,
    required super.userPoll,
  });

  static Map<String, dynamic> toMap({
    required String userId,
    required String longitude,
    required String latitude,
    required Map<String, dynamic>? note,
    required Map<String, dynamic>? userPoll,
    required Map<String, dynamic>? rating,
  }) {
    return {
      "userId": userId,
      "longitude": longitude,
      "latitude": latitude,
      "note": note,
      "userPoll": userPoll,
      "rating": rating,
      "dateCreated": convertTime(DateTime.now()),
      "favorites": [],
    };
  }
}
