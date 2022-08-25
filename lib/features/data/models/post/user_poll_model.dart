import 'package:hottake/features/domain/domain.dart';

class UserPollModel extends UserPollEntity {
  UserPollModel({
    required super.polls,
    required super.question,
    required super.userVotes,
  });
}

class PollModel extends PollEntity {
  PollModel({required super.option, required super.value});
}
