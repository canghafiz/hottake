class UserPollEntity {
  final List polls;
  String question;
  final Map<String, dynamic> userVotes;

  UserPollEntity({
    required this.polls,
    required this.question,
    required this.userVotes,
  });

  // Map
  static UserPollEntity fromMap(Map<String, dynamic> data) {
    return UserPollEntity(
      polls: data['polls'],
      question: data['question'],
      userVotes: data['userVotes'],
    );
  }

  static Map<String, dynamic> toMap({
    required List<Map<String, dynamic>> polls,
    required String question,
    Map<String, dynamic>? userVotes,
  }) {
    return {"polls": polls, "question": question, "userVotes": userVotes ?? {}};
  }
}

class PollEntity {
  final String option;
  final double value;

  PollEntity({required this.option, required this.value});

  // Map
  static PollEntity fromMap(Map<String, dynamic> data) {
    return PollEntity(
      option: data['option'],
      value: data['value'],
    );
  }

  static Map<String, dynamic> toMap({
    required String option,
    required double value,
  }) {
    return {"option": option, "value": value};
  }
}

class UserVoteEntity {
  final String userId;
  final int optionId;

  UserVoteEntity({
    required this.optionId,
    required this.userId,
  });

  // Map
  static Map<String, dynamic> toMap({
    required String userId,
    required int optionId,
  }) {
    return {
      userId: optionId,
    };
  }
}
