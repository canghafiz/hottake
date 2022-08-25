import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class UserPollCardWidget extends StatelessWidget {
  const UserPollCardWidget({
    Key? key,
    required this.userId,
    required this.userPoll,
    required this.theme,
  }) : super(key: key);
  final String userId;
  final UserPollEntity userPoll;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question
        Text(
          userPoll.question,
          style: fontStyle(
            size: 13,
            theme: theme,
            color: convertTheme(theme.primary),
          ),
        ),
        const SizedBox(height: 8),
        // Options
        Column(
          children: List.generate(
            userPoll.polls.length,
            (index) {
              final PollEntity poll = PollEntity.fromMap(userPoll.polls[index]);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Option
                        Expanded(
                          child: Text(
                            poll.option,
                            style: fontStyle(
                              size: 11,
                              theme: theme,
                              weight: FontWeight.bold,
                              color: convertTheme(theme.primary),
                            ),
                          ),
                        ),
                        // Value
                        Text(
                          "${userPollVoteValue(voteValue: poll.value, allPoll: userPoll)}%",
                          style: fontStyle(
                            size: 11,
                            theme: theme,
                            weight: FontWeight.bold,
                            color: convertTheme(theme.primary),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  (index != userPoll.polls.length - 1)
                      ? Container(
                          width: double.infinity,
                          height: 1,
                          color: convertTheme(theme.primary),
                        )
                      : const SizedBox(),
                ],
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

String userPollVoteValue({
  required double voteValue,
  required UserPollEntity allPoll,
}) {
  double totalVote = 0;

  for (int i = 0; i < allPoll.polls.length; i++) {
    // Model
    final PollEntity poll = PollEntity.fromMap(allPoll.polls[i]);

    totalVote += poll.value;
  }

  final vote = double.parse((voteValue * 100 / totalVote).toStringAsFixed(0));

  final regex = RegExp(r'([.]*0)(?!.*\d)');
  return (vote.toString() == "NaN")
      ? "0"
      : vote.toString().replaceAll(regex, "");
}
