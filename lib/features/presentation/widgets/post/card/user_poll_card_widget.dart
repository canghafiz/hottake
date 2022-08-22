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
                    // Question
                    Expanded(
                      child: Text(
                        poll.question,
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
                      "${poll.value}%",
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
    );
  }
}
