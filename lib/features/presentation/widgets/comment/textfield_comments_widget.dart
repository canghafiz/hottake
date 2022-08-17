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
            color: convertTheme(widget.theme.secondary),
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
                    color: convertTheme(widget.theme.third),
                  ),
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
                      color: convertTheme(widget.theme.third),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Send
              GestureDetector(
                onTap: () {
                  if (controller.text.isNotEmpty) {
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
                  color: convertTheme(widget.theme.third),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
