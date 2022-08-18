import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    Key? key,
    required this.enableClick,
    required this.post,
    required this.userId,
    required this.postId,
    required this.note,
    required this.rating,
    required this.userPoll,
    required this.theme,
  }) : super(key: key);
  final bool enableClick;
  final String userId, postId;
  final PostEntity post;
  final NoteEntity? note;
  final RatingEntity? rating;
  final UserPollEntity? userPoll;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enableClick) {
          // Navigate
          toMapPage(
            context: context,
            userId: userId,
            postId: postId,
            theme: theme,
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: convertTheme(theme.secondary),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 0),
              color: convertTheme(theme.secondary).withOpacity(0.5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type | From | Pop Btn (Only for yours)
            Row(
              children: [
                // Type | From
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type
                      Text(
                        (note != null)
                            ? "Note"
                            : (rating != null)
                                ? "Rating"
                                : "User Poll",
                        style: fontStyle(
                          size: 13,
                          theme: theme,
                          weight: FontWeight.bold,
                          color: convertTheme(theme.third),
                        ),
                      ),
                      // From
                      FutureBuilder<DocumentSnapshot>(
                        future: dI<UserFirestore>().getOneTimeUser(post.userId),
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              "Loading...",
                              style: fontStyle(
                                size: 13,
                                theme: theme,
                                weight: FontWeight.bold,
                                color:
                                    convertTheme(theme.third).withOpacity(0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          // Model
                          final UserEntity user = UserEntity.fromMap(
                              snapshot.data!.data() as Map<String, dynamic>);

                          return GestureDetector(
                            onTap: () {
                              // Navigate
                              toUserPage(
                                context: context,
                                userId: userId,
                                initialTab: 0,
                              );
                            },
                            child: Text(
                              "@${user.username}",
                              style: fontStyle(
                                size: 13,
                                theme: theme,
                                weight: FontWeight.bold,
                                color:
                                    convertTheme(theme.third).withOpacity(0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Pop Btn (Only for yours)
                (userId == post.userId)
                    ? PopupMenuButton(
                        color: convertTheme(theme.primary),
                        icon: Icon(
                          Icons.more_vert_outlined,
                          color: convertTheme(theme.third),
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            // Update State
                            dI<PostCubitEvent>().read(context).updateLocation(
                                  latitude: post.latitude,
                                  longitude: post.longitude,
                                );
                            // Note
                            if (note != null) {
                              dI<PostCubitEvent>().read(context).updateNote(
                                    title: note!.title,
                                    note: note!.note,
                                  );
                            }
                            // Rating
                            else if (rating != null) {
                              dI<PostCubitEvent>().read(context).updateRating(
                                    description: rating!.description,
                                    value: rating!.rating,
                                  );
                            }
                            // Poll
                            else {
                              dI<PostCubitEvent>().read(context).updatePolling(
                                    index: null,
                                    pollCubit: null,
                                    initial: true,
                                  );

                              for (int i = 0;
                                  i < userPoll!.polls.length - 1;
                                  i++) {
                                dI<PostCubitEvent>()
                                    .read(context)
                                    .updatePolling(
                                      index: null,
                                      pollCubit: null,
                                      initial: false,
                                    );
                              }

                              for (int i = 0; i < userPoll!.polls.length; i++) {
                                final PollEntity poll =
                                    PollEntity.fromMap(userPoll!.polls[i]);

                                dI<PostCubitEvent>()
                                    .read(context)
                                    .updatePolling(
                                      index: i,
                                      pollCubit: PollCubit(
                                        controller: TextEditingController(),
                                        poll: poll,
                                      ),
                                      initial: false,
                                    );
                              }
                            }

                            // Navigate
                            toPostLocationPage(
                              context: context,
                              userId: userId,
                              postId: postId,
                            );

                            return;
                          }

                          // Show Dialog
                          showDialog(
                            context: context,
                            builder: (context) => alertDialogTextWith2Button(
                              text: "Are you sure wanna delete this post?",
                              fontSize: 13,
                              fontColor: convertTheme(theme.third),
                              onfalse: () {
                                Navigator.pop(context);
                              },
                              onTrue: () {
                                dI<DeletePost>().call(postId);
                                Navigator.pop(context);
                              },
                              onFalseText: "Cancel",
                              onTrueText: "Yes",
                            ),
                          );
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              "Edit",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Delete",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 12),
            // Content | Btn Favorite & Comment
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content
                Expanded(
                  child: (note != null)
                      ? NoteCardWidget(
                          userId: userId,
                          note: note!,
                          theme: theme,
                        )
                      : (rating != null)
                          ? RatingCardWidget(
                              userId: userId,
                              rating: rating!,
                              theme: theme,
                            )
                          : UserPollCardWidget(
                              userId: userId,
                              userPoll: userPoll!,
                              theme: theme,
                            ),
                ),
                const SizedBox(width: 24),
                // Btn Favorite & Comment
                Column(
                  children: [
                    // Btn Favorite
                    btnFavoriteWidget(
                      userId: userId,
                      postId: postId,
                      contain: post.favorites.contains(userId),
                      theme: theme,
                      total: post.favorites.length,
                    ),
                    const SizedBox(height: 8),
                    // Btn Comment
                    GestureDetector(
                      onTap: () {
                        // Navigate
                        toCommentsPage(
                          context: context,
                          userId: userId,
                          postId: postId,
                          post: post,
                        );
                      },
                      child: Column(
                        children: [
                          // Icon
                          Icon(
                            Icons.chat_bubble_outlined,
                            color: convertTheme(theme.primary),
                          ),
                          // Total
                          Baseline(
                            baselineType: TextBaseline.alphabetic,
                            baseline: 8,
                            child: Text(
                              post.totalComments.toString(),
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                                color: convertTheme(theme.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Location Away | Date Created
            FutureBuilder<Position>(
              future: getCurrentLocationAndReturn(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    "Loading...",
                    style: fontStyle(
                      size: 10,
                      theme: theme,
                      color: convertTheme(theme.third).withOpacity(0.5),
                    ),
                  );
                }
                return Text(
                  "${distanceAway(firstPosition: LatLng(snapshot.data!.latitude, snapshot.data!.longitude), secondPosition: LatLng(double.parse(post.latitude), double.parse(post.longitude)))}m away - ${time(post.dateCreated)}",
                  style: fontStyle(
                    size: 10,
                    theme: theme,
                    color: convertTheme(theme.third).withOpacity(0.5),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget btnFavoriteWidget({
  required String userId,
  required String postId,
  required bool contain,
  required ThemeEntity theme,
  required int total,
}) {
  return GestureDetector(
    onTap: () {
      if (contain) {
        // Update Data
        dI<UpdateFavoritePost>().call(
          postId: postId,
          userId: userId,
          isAdd: false,
        );
        return;
      }

      // Update Data
      dI<UpdateFavoritePost>().call(
        postId: postId,
        userId: userId,
        isAdd: true,
      );
    },
    child: Column(
      children: [
        // Icon
        Icon(
          contain ? Icons.bookmark : Icons.bookmark_border_outlined,
          color: convertTheme(theme.primary),
        ),
        // Total
        Baseline(
          baselineType: TextBaseline.alphabetic,
          baseline: 8,
          child: Text(
            total.toString(),
            style: fontStyle(
              size: 11,
              theme: theme,
              color: convertTheme(theme.primary),
            ),
          ),
        ),
      ],
    ),
  );
}
