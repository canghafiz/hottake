import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class TextfieldCommentsWidget extends StatefulWidget {
  const TextfieldCommentsWidget({
    Key? key,
    required this.postId,
    required this.userId,
    required this.theme,
  }) : super(key: key);
  final ThemeEntity theme;
  final String userId, postId;

  @override
  State<TextfieldCommentsWidget> createState() =>
      _TextfieldCommentsWidgetState();
}

class _TextfieldCommentsWidgetState extends State<TextfieldCommentsWidget> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Update State
    dI<CommentCubitEvent>().read(context).clear();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CommentCubit, CommentState, CommentState>(
      selector: (state) => state,
      builder: (_, state) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 1 / 3,
        ),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: convertTheme(widget.theme.primary),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                offset: const Offset(0, 0),
                color: convertTheme(widget.theme.secondary).withOpacity(0.2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Textfield
              Expanded(
                child: TextField(
                  focusNode: state.focusNode,
                  autocorrect: true,
                  controller: controller,
                  style: fontStyle(
                    size: 13,
                    theme: widget.theme,
                  ),
                  cursorColor: convertTheme(widget.theme.secondary),
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: "Comment",
                    hintStyle: fontStyle(
                      size: 13,
                      theme: widget.theme,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Send
              FutureBuilder<DocumentSnapshot>(
                future: dI<PostFirestore>().getSinglePost(widget.postId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  // Model
                  final PostEntity post = PostEntity.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>);

                  return FutureBuilder<DocumentSnapshot>(
                    future: dI<UserFirestore>().getOneTimeUser(widget.userId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      // Model
                      final UserEntity user = UserEntity.fromMap(
                          snapshot.data!.data() as Map<String, dynamic>);

                      return GestureDetector(
                        onTap: () {
                          if (controller.text.isNotEmpty) {
                            // Call Notification
                            dI<NotificationService>().sendNotifPost(
                              postId: widget.postId,
                              comment: controller.text,
                              type: NotificationType.comment,
                              userId: post.userId,
                              myId: widget.userId,
                              username: user.username,
                            );

                            // Update Data
                            if (state.commentId == null) {
                              // Comment
                              dI<AddComment>().call(
                                postId: widget.postId,
                                userId: widget.userId,
                                comment: controller.text,
                              );

                              controller.clear();

                              // Update State
                              dI<CommentCubitEvent>().read(context).unFocus();
                            } else {
                              // SubComment
                              dI<AddSubComment>().call(
                                postId: widget.postId,
                                commentId: state.commentId!,
                                userId: widget.userId,
                                comment: controller.text,
                              );

                              controller.clear();

                              // Update State
                              dI<CommentCubitEvent>()
                                  .read(context)
                                  .updateCommentId(null);
                              dI<CommentCubitEvent>().read(context).unFocus();
                            }
                          }
                        },
                        child: Icon(
                          Icons.send_outlined,
                          color: convertTheme(widget.theme.secondary),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
