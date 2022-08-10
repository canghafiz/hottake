class UserPollEntity {
  final List polls;

  UserPollEntity(this.polls);

  // Map
  static UserPollEntity fromMap(Map<String, dynamic> data) {
    return UserPollEntity(data['polls']);
  }

  static Map<String, dynamic> toMap(List<Map<String, dynamic>> polls) {
    return {"polls": polls};
  }
}

class PollEntity {
  final String question;
  final int value;

  PollEntity({required this.question, required this.value});

  // Map
  static PollEntity fromMap(Map<String, dynamic> data) {
    return PollEntity(
      question: data['question'],
      value: data['value'],
    );
  }

  static Map<String, dynamic> toMap({
    required String question,
    required int value,
  }) {
    return {"question": question, "value": value};
  }
}
