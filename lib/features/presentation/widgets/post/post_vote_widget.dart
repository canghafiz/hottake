import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:flutter_polls/flutter_polls.dart';

class PostVoteWidget extends StatelessWidget {
  const PostVoteWidget({
    Key? key,
    required this.theme,
    required this.postId,
    required this.userId,
  }) : super(key: key);
  final ThemeEntity theme;
  final String userId, postId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: dI<PostFirestore>().getSingleNoteRealtime(postId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        // Model
        final PostEntity post =
            PostEntity.fromMap(snapshot.data!.data() as Map<String, dynamic>);
        final UserPollEntity? userPoll = (post.userPoll == null)
            ? null
            : UserPollEntity.fromMap(post.userPoll!);

        return (userPoll == null)
            ? const SizedBox()
            : ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  maxHeight: MediaQuery.of(context).size.height * 1 / 3,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: FlutterPolls(
                      pollId: postId,
                      hasVoted: userPoll.userVotes.containsKey(userId),
                      userVotedOptionId:
                          (userPoll.userVotes.containsKey(userId))
                              ? userPoll.userVotes[userId]
                              : null,
                      onVoted: (pollOption, newTotalVotes) async {
                        // Update Data
                        dI<UpdateVotePost>().call(
                          postId: postId,
                          userId: userId,
                          optionId: pollOption.id!,
                        );

                        return true;
                      },
                      pollTitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userPoll.question,
                          style: fontStyle(size: 13, theme: theme),
                        ),
                      ),
                      pollOptionsBorder: Border.all(
                        color: convertTheme(theme.secondary),
                      ),
                      votesTextStyle: fontStyle(
                        size: 13,
                        theme: theme,
                        color: convertTheme(theme.primary),
                      ),
                      votedBackgroundColor: convertTheme(theme.third),
                      votedCheckmark: Icon(
                        Icons.check_circle_outline,
                        color: convertTheme(theme.secondary),
                      ),
                      votedPercentageTextStyle: fontStyle(
                        size: 13,
                        theme: theme,
                      ),
                      pollOptions:
                          List.generate(userPoll.polls.length, (index) {
                        // Model
                        final PollEntity poll =
                            PollEntity.fromMap(userPoll.polls[index]);

                        return PollOption(
                          id: index,
                          title: Text(
                            poll.option,
                            style: fontStyle(
                              size: 13,
                              theme: theme,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          votes: int.parse(convertDoubleNumber(poll.value)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
