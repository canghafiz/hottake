class NoteEntity {
  final String title, note;

  NoteEntity({required this.note, required this.title});

  // Map
  static NoteEntity fromMap(Map<String, dynamic> data) {
    return NoteEntity(
      note: data['note'],
      title: data['title'],
    );
  }

  static Map<String, dynamic> toMap({
    required String title,
    required String note,
  }) {
    return {
      "title": title,
      "note": note,
    };
  }
}
