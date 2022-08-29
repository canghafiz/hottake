import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

Widget postDetailWidget({
  required String userId,
  required String postId,
  required PostEntity post,
  required NoteEntity? note,
  required RatingEntity? rating,
  required UserPollEntity? userPoll,
  required ThemeEntity theme,
  required User user,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Top
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: convertTheme(theme.primary),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            (note != null)
                ? "NOTE"
                : (rating != null)
                    ? "RATING"
                    : "USER POLL",
            style: fontStyle(size: 15, theme: theme),
          ),
        ),
      ),
      // Content
      Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                PostCardWidget(
                  post: post,
                  userId: userId,
                  postId: postId,
                  note: note,
                  rating: rating,
                  userPoll: userPoll,
                  theme: theme,
                  enableClick: false,
                  userAuth: user,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
