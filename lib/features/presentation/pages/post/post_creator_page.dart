import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PostCreatorPage extends StatelessWidget {
  const PostCreatorPage({
    Key? key,
    required this.postId,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final String? postId;
  final String userId;
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        backgroundColor: convertTheme(theme.primary).withOpacity(0.7),
        endDrawer: drawer(
          theme: theme,
          context: context,
          userId: userId,
          user: user,
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: convertTheme(theme.secondary),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Title
                Text(
                  "Post a HotTake",
                  style: fontStyle(size: 17, theme: theme),
                ),
                const SizedBox(height: 24),
                // Btn Choose Type
                BlocSelector<PostCubit, PostState, PostState>(
                  selector: (state) => state,
                  builder: (_, state) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: convertTheme(theme.primary),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Note
                        btnTypePostCreatorWidget(
                          onTap: () {
                            // Update State
                            dI<PostCubitEvent>().read(context).updateNote(
                                  title: "",
                                  note: "",
                                );
                          },
                          theme: theme,
                          title: 'Note',
                          isActive: state.note != null,
                        ),
                        // Poll
                        btnTypePostCreatorWidget(
                          onTap: () {
                            // Update State
                            dI<PostCubitEvent>().read(context).updatePolling(
                                  index: null,
                                  pollCubit: null,
                                  initial: true,
                                  question: null,
                                );
                          },
                          theme: theme,
                          title: 'Poll',
                          isActive: state.userPoll != null,
                        ),
                        // Rating
                        btnTypePostCreatorWidget(
                          onTap: () {
                            // Update State
                            dI<PostCubitEvent>().read(context).updateRating(
                                  description: "",
                                  value: 0,
                                );
                          },
                          theme: theme,
                          title: 'Rating',
                          isActive: state.rating != null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Content
                Container(
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
                  child: BlocSelector<PostCubit, PostState, PostState>(
                    selector: (state) => state,
                    builder: (_, state) => postCreatorContentDefine(
                      postId: postId,
                      userId: userId,
                      note: state.note,
                      polling: state.userPoll,
                      rating: state.rating,
                      theme: theme,
                      user: user,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget btnTypePostCreatorWidget({
  required Function onTap,
  required ThemeEntity theme,
  required String title,
  required bool isActive,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: convertTheme(isActive ? theme.secondary : theme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            title,
            style: fontStyle(
              size: 13,
              theme: theme,
              color: isActive ? convertTheme(theme.primary) : null,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget postCreatorContentDefine({
  required String? postId,
  required String userId,
  required NoteEntity? note,
  required UserPollEntity? polling,
  required RatingEntity? rating,
  required ThemeEntity theme,
  required User user,
}) {
  // Note
  if (note != null) {
    return NoteCreatorwidget(
      theme: theme,
      userId: userId,
      postId: postId,
      user: user,
    );
  }
  // Polling
  if (polling != null) {
    return PollingCreatorWidget(
      theme: theme,
      userId: userId,
      postId: postId,
      user: user,
    );
  }
  return RatingCreatorWidget(
    theme: theme,
    userId: userId,
    postId: postId,
    user: user,
  );
}
