import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({
    Key? key,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final String userId;
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        endDrawer: drawer(
          theme: theme,
          context: context,
          userId: userId,
          user: user,
        ),
        appBar: AppBar(
          title: Text(
            "Favourites",
            style: fontStyle(size: 17, theme: theme),
          ),
          iconTheme: IconThemeData(color: convertTheme(theme.secondary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: dI<PostFirestore>().getNotes(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: convertTheme(theme.primary),
                ),
              );
            }

            var filter = snapshot.data!.docs.where((doc) {
              // Model
              final PostEntity post =
                  PostEntity.fromMap(doc.data() as Map<String, dynamic>);

              return post.favorites.contains(userId);
            }).toList();

            return (filter.isEmpty)
                ? Center(
                    child: Text(
                      "Empty",
                      style: fontStyle(size: 13, theme: theme),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          // Total
                          Text(
                            "Total notes: ${filter.length}",
                            style: fontStyle(
                              size: 13,
                              theme: theme,
                              weight: FontWeight.w500,
                            ),
                          ),
                          // Notes
                          const SizedBox(height: 12),
                          Column(
                            children: filter.map(
                              (doc) {
                                // Model
                                final PostEntity post = PostEntity.fromMap(
                                    doc.data() as Map<String, dynamic>);

                                final NoteEntity? note = (post.note == null)
                                    ? null
                                    : NoteEntity.fromMap(post.note!);

                                final RatingEntity? rating =
                                    (post.rating == null)
                                        ? null
                                        : RatingEntity.fromMap(post.rating!);

                                final UserPollEntity? userPoll = (post
                                            .userPoll ==
                                        null)
                                    ? null
                                    : UserPollEntity.fromMap(post.userPoll!);

                                return PostCardWidget(
                                  enableClick: true,
                                  post: post,
                                  userId: userId,
                                  postId: doc.id,
                                  note: note,
                                  rating: rating,
                                  userPoll: userPoll,
                                  theme: theme,
                                  userAuth: user,
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
