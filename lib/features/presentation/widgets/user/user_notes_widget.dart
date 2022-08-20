import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class UserNotesWidget extends StatelessWidget {
  const UserNotesWidget({
    Key? key,
    required this.theme,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final ThemeEntity theme;
  final String userId;
  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dI<PostFirestore>().getMyNoteRealtime(userId),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Loading...",
              style: fontStyle(size: 13, theme: theme),
            ),
          );
        }
        return (snapshot.data!.docs.isEmpty)
            ? Center(
                child: Text(
                  "Empty",
                  style: fontStyle(size: 13, theme: theme),
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Total
                      Text(
                        "Total notes: ${snapshot.data!.docs.length}",
                        style: fontStyle(
                          size: 13,
                          theme: theme,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Notes
                      Column(
                        children: snapshot.data!.docs.map((doc) {
                          // Model
                          final PostEntity post = PostEntity.fromMap(
                              doc.data() as Map<String, dynamic>);

                          final NoteEntity? note = (post.note == null)
                              ? null
                              : NoteEntity.fromMap(post.note!);

                          final RatingEntity? rating = (post.rating == null)
                              ? null
                              : RatingEntity.fromMap(post.rating!);

                          final UserPollEntity? userPoll =
                              (post.userPoll == null)
                                  ? null
                                  : UserPollEntity.fromMap(post.userPoll!);

                          return PostCardWidget(
                            enableClick: true,
                            post: post,
                            userId: userId,
                            postId: doc.id,
                            note: note,
                            rating: rating,
                            userPoll: userPoll,
                            theme: theme,
                            userAuth: user,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
