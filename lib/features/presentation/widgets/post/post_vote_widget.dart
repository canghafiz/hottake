import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';

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
            : SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              );
      },
    );
  }
}
