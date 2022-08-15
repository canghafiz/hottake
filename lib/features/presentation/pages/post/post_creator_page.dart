import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PostCreatorPage extends StatelessWidget {
  const PostCreatorPage({
    Key? key,
    required this.postId,
    required this.userId,
  }) : super(key: key);
  final String? postId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: convertTheme(theme.primary),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top
                    Row(
                      children: [
                        // Back
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: convertTheme(theme.secondary),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Title
                        Flexible(
                          child: Text(
                            "Post a HotTake",
                            style: fontStyle(
                              size: 13,
                              theme: theme,
                              weight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Content
                    BlocSelector<PostCubit, PostState, PostState>(
                      selector: (state) => state,
                      builder: (_, state) => SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                  color: convertTheme(theme.third),
                                ),
                              ),
                              child: Text(
                                postCreatorTitleDefine(
                                  note: state.note,
                                  polling: state.userPoll,
                                  rating: state.rating,
                                ),
                                style: fontStyle(size: 11, theme: theme),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Content
                            postCreatorContentDefine(
                              postId: postId,
                              userId: userId,
                              note: state.note,
                              polling: state.userPoll,
                              rating: state.rating,
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String postCreatorTitleDefine({
  required NoteEntity? note,
  required UserPollEntity? polling,
  required RatingEntity? rating,
}) {
  // Note
  if (note != null) {
    return "Note";
  }
  // Polling
  if (polling != null) {
    return "User Poll";
  }
  return "Rating";
}

Widget postCreatorContentDefine({
  required String? postId,
  required String userId,
  required NoteEntity? note,
  required UserPollEntity? polling,
  required RatingEntity? rating,
  required ThemeEntity theme,
}) {
  // Note
  if (note != null) {
    return NoteCreatorwidget(
      theme: theme,
      userId: userId,
      postId: postId,
    );
  }
  // Polling
  if (polling != null) {
    return PollingCreatorWidget(theme: theme, userId: userId, postId: postId);
  }
  return RatingCreatorWidget(theme: theme, userId: userId, postId: postId);
}
