import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({
    Key? key,
    required this.postId,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final String userId, postId;
  final User user;

  @override
  Widget build(BuildContext context) {
    // Update State
    dI<CommentCubitEvent>().read(context).clear();

    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                // Vote
                PostVoteWidget(postId: postId, userId: userId, theme: theme),
                // Contents
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 19,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: convertTheme(theme.primary),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                          color: convertTheme(theme.secondary).withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            color: convertTheme(theme.primary),
                          ),
                          child: Row(
                            children: [
                              // Back
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: convertTheme(theme.secondary),
                                ),
                              ),
                              // Total
                              Flexible(
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: dI<PostFirestore>()
                                      .getSingleNoteRealtime(postId),
                                  builder: (_, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: Text(
                                          "Loading...",
                                          style: fontStyle(
                                            size: 13,
                                            theme: theme,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }
                                    // Model
                                    final PostEntity post = PostEntity.fromMap(
                                        snapshot.data!.data()
                                            as Map<String, dynamic>);

                                    return Center(
                                      child: Text(
                                        "${post.totalComments} Comments",
                                        style: fontStyle(
                                          size: 13,
                                          theme: theme,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Comments
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: dI<CommentFirestore>().getComments(postId),
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
                                        style:
                                            fontStyle(size: 13, theme: theme),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: snapshot.data!.docs.map(
                                          (doc) {
                                            // Model
                                            final CommentEntity comment =
                                                CommentEntity.fromMap(doc.data()
                                                    as Map<String, dynamic>);

                                            return CommentCardWidget(
                                              userId: userId,
                                              subCommentId: null,
                                              comment: comment,
                                              theme: theme,
                                              commentId: doc.id,
                                              postId: postId,
                                              userAuth: user,
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Textfield
                TextfieldCommentsWidget(
                  postId: postId,
                  userId: userId,
                  theme: theme,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
