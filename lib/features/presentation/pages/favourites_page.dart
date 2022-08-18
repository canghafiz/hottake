import 'package:cloud_firestore/cloud_firestore.dart';
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
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: dI<PostFirestore>().getFavoriteNotes(userId),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: convertTheme(theme.primary),
                ),
              );
            }
            return (snapshot.data!.docs.isEmpty)
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
                        children: snapshot.data!.docs.map(
                          (doc) {
                            // Model
                            final PostEntity post = PostEntity.fromMap(
                                doc.data() as Map<String, dynamic>);

                            final NoteEntity? note = (post.note == null)
                                ? null
                                : NoteEntity.fromMap(post.note!);

                            final RatingEntity? rating = (post.rating == null)
                                ? null
                                : RatingEntity.fromMap(post.rating!);

                            final UserPollEntity? userPoll =
                                (post.userPoll == null)
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
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
