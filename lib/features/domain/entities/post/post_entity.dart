import 'package:hottake/core/core.dart';

class PostEntity {
  final String userId, longitude, latitude, dateCreated;
  final List favorites, likes, unlikes, reads;
  final Map<String, dynamic>? note, userPoll, rating;
  final int totalComments, totalFavorites, totalLikes, totalUnlikes;

  PostEntity({
    required this.dateCreated,
    required this.favorites,
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.rating,
    required this.userId,
    required this.userPoll,
    required this.totalComments,
    required this.totalFavorites,
    required this.likes,
    required this.totalLikes,
    required this.totalUnlikes,
    required this.unlikes,
    required this.reads,
  });

  // Map
  static PostEntity fromMap(Map<String, dynamic> data) {
    return PostEntity(
      dateCreated: data['dateCreated'],
      favorites: data['favorites'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      note: data['note'],
      rating: data['rating'],
      userId: data['userId'],
      userPoll: data['userPoll'],
      totalComments: data['totalComments'],
      totalFavorites: data['totalFavorites'],
      likes: data['likes'],
      totalLikes: data['totalLikes'],
      totalUnlikes: data['totalUnLikes'],
      unlikes: data['unLikes'],
      reads: data['reads'],
    );
  }

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
      "likes": [],
      "unLikes": [],
      "reads": [],
      "totalFavorites": 0,
      "totalComments": 0,
      "totalLikes": 0,
      "totalUnLikes": 0,
    };
  }
}
