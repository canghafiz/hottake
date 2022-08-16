import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.mainComment,
    required this.comment,
    required this.theme,
  }) : super(key: key);
  final String userId, postId, commentId;
  final bool mainComment;
  final CommentEntity comment;
  final ThemeEntity theme;

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
                          );
                        },
                        child: Text(
                          "@" + user.username,
                          style: fontStyle(
                            size: 11,
                            theme: theme,
                            color: convertTheme(theme.third).withOpacity(0.5),
                            weight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Comment
                      Text(
                        comment.comments,
                        style: fontStyle(
                          size: 11,
                          theme: theme,
                          color: convertTheme(theme.third),
                        ),
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
                      if (mainComment) {
                        dI<UpdateFavoriteComment>().call(
                          postId: postId,
                          commentId: commentId,
                          userId: userId,
                          isAdd: true,
                        );
                      }
                    } else {
                      // Min
                      // Main
                      if (mainComment) {
                        dI<UpdateFavoriteComment>().call(
                          postId: postId,
                          commentId: commentId,
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
