import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PostNearbyWidget extends StatelessWidget {
  const PostNearbyWidget({
    Key? key,
    required this.userId,
    required this.theme,
    required this.user,
  }) : super(key: key);
  final String userId;
  final ThemeEntity theme;
  final User user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: getCurrentLocationAndReturn(),
      builder: (_, snapshotLoc) {
        if (!snapshotLoc.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: convertTheme(theme.primary),
            ),
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: dI<PostFirestore>().getNotes(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: convertTheme(theme.primary),
                ),
              );
            }

            var data = snapshot.data!.docs.where((doc) {
              // Model
              final PostEntity post =
                  PostEntity.fromMap(doc.data() as Map<String, dynamic>);

              return locationOnRadius(
                current: LatLng(
                    snapshotLoc.data!.latitude, snapshotLoc.data!.longitude),
                postLoc: LatLng(
                  double.parse(post.latitude),
                  double.parse(post.longitude),
                ),
              );
            }).toList();

            List<Map<String, dynamic>> sort = [];

            for (DocumentSnapshot doc in data) {
              // Model
              final PostEntity post =
                  PostEntity.fromMap(doc.data() as Map<String, dynamic>);

              sort.add(
                {
                  "doc": doc,
                  "weight": distanceAway(
                    firstPosition: LatLng(snapshotLoc.data!.latitude,
                        snapshotLoc.data!.longitude),
                    secondPosition: LatLng(
                      double.parse(post.latitude),
                      double.parse(post.longitude),
                    ),
                  ),
                },
              );
            }

            sort.sort((a, b) {
              return a['weight'].compareTo(b['weight']);
            });

            return (sort.isEmpty)
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
                            "Total notes: ${sort.length}",
                            style: fontStyle(
                              size: 13,
                              theme: theme,
                              weight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Notes
                          Column(
                            children: sort.map((map) {
                              // Model
                              final PostEntity post = PostEntity.fromMap(
                                  (map["doc"] as DocumentSnapshot).data()
                                      as Map<String, dynamic>);

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
                                postId: (map['doc'] as DocumentSnapshot).id,
                                note: note,
                                rating: rating,
                                userPoll: userPoll,
                                theme: theme,
                                userAuth: user,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        );
      },
    );
  }
}
