import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
    required this.userAuth,
  }) : super(key: key);
  final bool enableClick;
  final String userId, postId;
  final PostEntity post;
  final NoteEntity? note;
  final RatingEntity? rating;
  final UserPollEntity? userPoll;
  final ThemeEntity theme;
  final User userAuth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate
        toCommentsPage(
          context: context,
          userId: userId,
          postId: postId,
          post: post,
          user: userAuth,
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                                color: convertTheme(theme.secondary)
                                    .withOpacity(0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          // Model
                          final UserEntity user = UserEntity.fromMap(
                              snapshot.data!.data() as Map<String, dynamic>);

                          return Text(
                            "@${user.username}",
                            style: fontStyle(
                              size: 13,
                              theme: theme,
                              weight: FontWeight.bold,
                              color: convertTheme(theme.secondary)
                                  .withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Pop Btn (Only for yours)
                PopupMenuButton(
                  color: convertTheme(theme.primary),
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: convertTheme(theme.secondary),
                  ),
                  onSelected: (value) {
                    // Open Location
                    if (value == 0) {
                      // Navigate
                      toMapPage(
                        context: context,
                        userId: userId,
                        postId: postId,
                        theme: theme,
                        user: userAuth,
                      );
                    }
                    // Open Location  on Google Map
                    if (value == 1) {
                      launchUrlString(
                        'https://www.google.com/maps/search/?api=1&query=${post.latitude},${post.longitude}',
                      );
                    }
                    // Edit
                    if (value == 2 && (userId == post.userId)) {
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
                              question: null,
                              userVotes: userPoll!.userVotes,
                            );

                        for (int i = 0; i < userPoll!.polls.length - 1; i++) {
                          dI<PostCubitEvent>().read(context).updatePolling(
                                index: null,
                                pollCubit: null,
                                initial: false,
                                question: null,
                              );
                        }

                        for (int i = 0; i < userPoll!.polls.length; i++) {
                          final PollEntity poll =
                              PollEntity.fromMap(userPoll!.polls[i]);

                          dI<PostCubitEvent>().read(context).updatePolling(
                                index: i,
                                pollCubit: PollCubit(
                                  controller: TextEditingController(),
                                  poll: poll,
                                ),
                                initial: false,
                                question: userPoll!.question,
                              );
                        }
                      }

                      // Navigate
                      toPostLocationPage(
                        context: context,
                        userId: userId,
                        postId: postId,
                        user: userAuth,
                      );

                      return;
                    }
                    // Delete
                    if (value == 3 && (userId == post.userId)) {
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
                    }
                  },
                  itemBuilder: (context) => (userId == post.userId)
                      ? [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              "Open Location",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Open Location In Google Maps",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text(
                              "Edit",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 3,
                            child: Text(
                              "Delete",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                        ]
                      : [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              "Open Location",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Open Location In Google Maps",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                              ),
                            ),
                          ),
                        ],
                )
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
                // Btn Likes | UnLikes | Favorite & Comment
                Column(
                  children: [
                    // Btn Like
                    btnLikeWidget(
                      userId: userId,
                      postId: postId,
                      contain: post.likes.contains(userId),
                      theme: theme,
                      total: post.likes.length,
                    ),
                    const SizedBox(height: 8),
                    // Btn UnLike
                    btnUnLikeWidget(
                      userId: userId,
                      postId: postId,
                      contain: post.unlikes.contains(userId),
                      theme: theme,
                      total: post.unlikes.length,
                    ),
                    const SizedBox(height: 8),
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
                          user: userAuth,
                        );
                      },
                      child: Column(
                        children: [
                          // Icon
                          Icon(
                            Icons.chat_bubble_outlined,
                            color: convertTheme(theme.secondary),
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
                    ),
                  );
                }
                return Text(
                  "${distanceAway(firstPosition: LatLng(snapshot.data!.latitude, snapshot.data!.longitude), secondPosition: LatLng(double.parse(post.latitude), double.parse(post.longitude)))}m away - ${time(post.dateCreated)}",
                  style: fontStyle(
                    size: 10,
                    theme: theme,
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
          color: convertTheme(theme.secondary),
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
            ),
          ),
        ),
      ],
    ),
  );
}

Widget btnLikeWidget({
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
        dI<UpdateLikePost>().call(
          postId: postId,
          userId: userId,
          isAdd: false,
        );

        return;
      }

      // Update Data
      dI<UpdateLikePost>().call(
        postId: postId,
        userId: userId,
        isAdd: true,
      );
    },
    child: Column(
      children: [
        // Icon
        Icon(
          Icons.arrow_upward,
          color: contain
              ? convertTheme(theme.secondary)
              : convertTheme(theme.secondary).withOpacity(0.5),
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
            ),
          ),
        ),
      ],
    ),
  );
}

Widget btnUnLikeWidget({
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
        dI<UpdateUnLikePost>().call(
          postId: postId,
          userId: userId,
          isAdd: false,
        );

        return;
      }

      // Update Data
      dI<UpdateUnLikePost>().call(
        postId: postId,
        userId: userId,
        isAdd: true,
      );
    },
    child: Column(
      children: [
        // Icon
        Icon(
          Icons.arrow_downward,
          color: contain
              ? convertTheme(theme.secondary)
              : convertTheme(theme.secondary).withOpacity(0.5),
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
            ),
          ),
        ),
      ],
    ),
  );
}
