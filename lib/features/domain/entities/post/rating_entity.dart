class RatingEntity {
  final double rating;
  final String description;

  RatingEntity({required this.description, required this.rating});

  // Map
  static RatingEntity fromMap(Map<String, dynamic> data) {
    return RatingEntity(
      description: data['description'],
      rating: data['rating'],
    );
  }

  static Map<String, dynamic> toMap({
    required double rating,
    required String description,
  }) {
    return {"rating": rating, "description": description};
  }
}
