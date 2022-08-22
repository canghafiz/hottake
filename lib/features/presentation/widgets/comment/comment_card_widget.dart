import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class CommentCardWidget extends StatelessWidget {
  const CommentCardWidget({
    Key? key,
    required this.userId,
    required this.postId,
    required this.commentId,
    required this.subCommentId,
    required this.comment,
    required this.theme,
    required this.userAuth,
  }) : super(key: key);
  final String userId, postId, commentId;
  final String? subCommentId;
  final CommentEntity comment;
  final ThemeEntity theme;
  final User userAuth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<DocumentSnapshot>(
          future: dI<UserFirestore>().getOneTimeUser(comment.userId),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: convertTheme(theme.primary),
                ),
              );
            }
            // Model
            final UserEntity user = UserEntity.fromMap(
                snapshot.data!.data() as Map<String, dynamic>);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo Profile
                PhotoProfileWidget(
                  url: user.photo,
                  size: 16,
                  theme: theme,
                ),
                const SizedBox(width: 8),
                // Username | Comment | Reply
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      GestureDetector(
                        onTap: () {
                          // Navigate
                          toUserPage(
                            context: context,
                            userId: comment.userId,
                            initialTab: 0,
                            user: userAuth,
                            forOwn: (userId == comment.userId),
                          );
                        },
                        child: Text(
                          "@" + user.username,
                          style: fontStyle(
                            size: 13,
                            theme: theme,
                            color: convertTheme(theme.primary).withOpacity(0.5),
                            weight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Comment
                      Text(
                        comment.comments,
                        style: fontStyle(
                          size: 13,
                          theme: theme,
                          color: convertTheme(theme.primary),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Sub
                      SubCommentWidget(
                        subCommentId: subCommentId,
                        commentId: commentId,
                        postId: postId,
                        userId: userId,
                        comment: comment,
                        theme: theme,
                        userAuth: userAuth,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Favorite
                GestureDetector(
                  onTap: () {
                    // Update Data
                    if (!comment.favorites.contains(userId)) {
                      // Add
                      // Main
                      if (subCommentId == null) {
                        dI<UpdateFavoriteComment>().call(
                          postId: postId,
                          commentId: commentId,
                          userId: userId,
                          isAdd: true,
                        );
                      } else {
                        // Sub
                        dI<UpdateFavoriteSubComment>().call(
                          postId: postId,
                          commentId: commentId,
                          subCommentId: subCommentId!,
                          userId: userId,
                          isAdd: true,
                        );
                      }
                    } else {
                      // Min
                      // Main
                      if (subCommentId == null) {
                        dI<UpdateFavoriteComment>().call(
                          postId: postId,
                          commentId: commentId,
                          userId: userId,
                          isAdd: false,
                        );
                      } else {
                        // Sub
                        dI<UpdateFavoriteSubComment>().call(
                          postId: postId,
                          commentId: commentId,
                          subCommentId: subCommentId!,
                          userId: userId,
                          isAdd: false,
                        );
                      }
                    }
                  },
                  child: Column(
                    children: [
                      // Icon
                      Icon(
                        (comment.favorites.contains(userId))
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: convertTheme(theme.primary),
                      ),
                      // Total
                      Text(
                        comment.favorites.length.toString(),
                        style: fontStyle(
                          size: 11,
                          theme: theme,
                          color: convertTheme(theme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class SubCommentWidget extends StatefulWidget {
  const SubCommentWidget({
    Key? key,
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.comment,
    required this.theme,
    required this.subCommentId,
    required this.userAuth,
  }) : super(key: key);
  final String? subCommentId;
  final String userId, postId, commentId;
  final CommentEntity comment;
  final ThemeEntity theme;
  final User userAuth;

  @override
  State<SubCommentWidget> createState() => _SubCommentWidgetState();
}

class _SubCommentWidgetState extends State<SubCommentWidget> {
  bool showReplies = false;

  void updateShow() {
    setState(() {
      showReplies = !showReplies;
    });
  }

  Widget replyAndDate() {
    return Row(
      children: [
        // Reply
        GestureDetector(
          onTap: () {
            // Update state
            dI<CommentCubitEvent>().read(context).showFocus();
            dI<CommentCubitEvent>()
                .read(context)
                .updateCommentId(widget.commentId);
          },
          child: Text(
            "Reply",
            style: fontStyle(
              size: 9,
              theme: widget.theme,
              color: convertTheme(widget.theme.primary).withOpacity(0.5),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Date
        Flexible(
          child: Text(
            " - " + timeDuration(widget.comment.date),
            style: fontStyle(
              size: 9,
              theme: widget.theme,
              color: convertTheme(widget.theme.primary).withOpacity(0.5),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return (widget.subCommentId != null)
        ? replyAndDate()
        : StreamBuilder<QuerySnapshot>(
            stream: dI<CommentFirestore>().getSubComments(
              postId: widget.postId,
              commentId: widget.commentId,
            ),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: convertTheme(widget.theme.primary),
                  ),
                );
              }
              return (snapshot.data!.docs.isEmpty)
                  ? replyAndDate()
                  : !showReplies
                      ?
                      // Btn Replies
                      GestureDetector(
                          onTap: () {
                            updateShow();
                          },
                          child: Row(
                            children: [
                              // Text
                              Text(
                                "View repliies (${snapshot.data!.docs.length})",
                                style: fontStyle(
                                  size: 11,
                                  theme: widget.theme,
                                  color: convertTheme(widget.theme.primary)
                                      .withOpacity(0.5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Icon
                              Icon(
                                Icons.arrow_drop_down,
                                color: convertTheme(widget.theme.primary)
                                    .withOpacity(0.5),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            replyAndDate(),
                            const SizedBox(height: 16),
                            // Replies
                            Column(
                              children: snapshot.data!.docs.map(
                                (doc) {
                                  // Model
                                  final CommentEntity comment =
                                      CommentEntity.fromMap(
                                          doc.data() as Map<String, dynamic>);

                                  return CommentCardWidget(
                                    userId: widget.userId,
                                    postId: widget.postId,
                                    commentId: widget.commentId,
                                    subCommentId: doc.id,
                                    comment: comment,
                                    theme: widget.theme,
                                    userAuth: widget.userAuth,
                                  );
                                },
                              ).toList(),
                            ),
                            // Btn Hide
                            GestureDetector(
                              onTap: () {
                                updateShow();
                              },
                              child: Text(
                                "Hide repliies (${snapshot.data!.docs.length})",
                                style: fontStyle(
                                  size: 11,
                                  theme: widget.theme,
                                  color: convertTheme(widget.theme.primary)
                                      .withOpacity(0.5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
            },
          );
  }
}
