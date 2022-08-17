import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PostChoosePage extends StatelessWidget {
  const PostChoosePage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        "Post a HotTake",
                        style: fontStyle(
                          size: 13,
                          theme: theme,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Type
                      BlocSelector<PostCubit, PostState, PostState>(
                        selector: (state) => state,
                        builder: (_, state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Note
                            noteChooseTypeWidget(
                              onTap: () {
                                // Update State
                                dI<PostCubitEvent>().read(context).updateNote(
                                      title: "",
                                      note: "",
                                    );
                              },
                              theme: theme,
                              title: "Note",
                              selected: state.note != null,
                              context: context,
                              userId: userId,
                            ),
                            const SizedBox(height: 8),
                            // User Poll
                            noteChooseTypeWidget(
                              onTap: () {
                                // Update State
                                dI<PostCubitEvent>()
                                    .read(context)
                                    .updatePolling(
                                      index: null,
                                      pollCubit: null,
                                      initial: true,
                                    );
                              },
                              theme: theme,
                              title: "Polling",
                              selected: state.userPoll != null,
                              context: context,
                              userId: userId,
                            ),
                            const SizedBox(height: 8),
                            // Rating
                            noteChooseTypeWidget(
                              onTap: () {
                                // Update State
                                dI<PostCubitEvent>().read(context).updateRating(
                                      description: "",
                                      value: 0,
                                    );
                              },
                              theme: theme,
                              title: "Rating",
                              selected: state.rating != null,
                              context: context,
                              userId: userId,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget noteChooseTypeWidget({
  required Function onTap,
  required ThemeEntity theme,
  required String title,
  required bool selected,
  required BuildContext context,
  required String userId,
}) {
  return GestureDetector(
    onTap: () {
      onTap.call();

      // Update State
      dI<PostCubitEvent>().read(context).updateLocation(
            latitude: null,
            longitude: null,
          );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: selected
              ? const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                )
              : null,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color:
                selected ? convertTheme(theme.secondary) : Colors.transparent,
          ),
          child: Text(
            title,
            style: fontStyle(
              size: 11,
              theme: theme,
              color: selected ? convertTheme(theme.primary) : null,
            ),
          ),
        ),
        selected
            ? IconButton(
                onPressed: () {
                  // Navigate
                  toPostLocationPage(
                    context: context,
                    userId: userId,
                    postId: null,
                  );

                  onTap.call();
                },
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: convertTheme(theme.secondary),
                ),
              )
            : const SizedBox(),
      ],
    ),
  );
}
