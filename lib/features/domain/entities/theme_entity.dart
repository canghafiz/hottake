class ThemeEntity {
  final String primary, secondary, third;

  ThemeEntity({
    required this.primary,
    required this.secondary,
    required this.third,
  });

  static ThemeEntity fromMap(Map<String, dynamic> data) {
    return ThemeEntity(
      primary: data['primary'],
      secondary: data['secondary'],
      third: data['third'],
    );
  }

  static Map<String, dynamic> toMap({
    required String primary,
    required String secondary,
    required String third,
  }) {
    return {
      "primary": primary,
      "secondary": secondary,
      "third": third,
    };
  }
}
