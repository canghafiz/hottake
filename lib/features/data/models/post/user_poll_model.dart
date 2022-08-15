import 'package:hottake/features/domain/domain.dart';

class UserPollModel extends UserPollEntity {
  UserPollModel(super.polls);
}

class PollModel extends PollEntity {
  PollModel({required super.question, required super.value});
}
