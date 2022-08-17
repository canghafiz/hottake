import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({
    Key? key,
    required this.post,
    required this.postId,
    required this.userId,
  }) : super(key: key);
  final PostEntity post;
  final String userId, postId;

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
                      color: convertTheme(theme.secondary),
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
                            color: convertTheme(theme.secondary),
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
                                  color: convertTheme(theme.third),
                                ),
                              ),
                              // Total
                              Flexible(
                                child: Center(
                                  child: Text(
                                    "${post.totalComments} Comments",
                                    style: fontStyle(
                                      size: 13,
                                      theme: theme,
                                      color: convertTheme(theme.third),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                                              mainComment: true,
                                              comment: comment,
                                              theme: theme,
                                              commentId: doc.id,
                                              postId: postId,
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
