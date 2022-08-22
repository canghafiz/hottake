import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class UserNotesWidget extends StatefulWidget {
  const UserNotesWidget({
    Key? key,
    required this.theme,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final ThemeEntity theme;
  final String userId;
  final User user;

  @override
  State<UserNotesWidget> createState() => _UserNotesWidgetState();
}

class _UserNotesWidgetState extends State<UserNotesWidget> {
  var orderType = PostOrderType.nearest;

  void updateOrderType(PostOrderType value) {
    setState(() {
      orderType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget dropDownSort() {
      return DropdownButton<PostOrderType>(
        value: orderType,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(
            value: PostOrderType.nearest,
            child: Text("Nearest"),
          ),
          DropdownMenuItem(
            value: PostOrderType.latest,
            child: Text("Latest"),
          ),
          DropdownMenuItem(
            value: PostOrderType.popular,
            child: Text("Most Popular"),
          ),
          DropdownMenuItem(
            value: PostOrderType.controversial,
            child: Text("Most Controversial"),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            updateOrderType(value);
          }
        },
      );
    }

    return FutureBuilder<Position>(
        future: getCurrentLocationAndReturn(),
        builder: (context, snapshotLoc) {
          if (!snapshotLoc.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: convertTheme(widget.theme.primary),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: dI<PostFirestore>()
                .getMyNoteRealtime(userId: widget.userId, type: orderType),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    "Loading...",
                    style: fontStyle(size: 13, theme: widget.theme),
                  ),
                );
              }
              var data = snapshot.data!.docs.toList();

              List<Map<String, dynamic>>? sort =
                  (orderType == PostOrderType.nearest) ? [] : null;

              // Nearest
              if (sort != null) {
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
              }

              return (sort != null)
                  ? SingleChildScrollView(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Total notes: ${sort.length}",
                                    style: fontStyle(
                                      size: 13,
                                      theme: widget.theme,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Dropdown
                                dropDownSort(),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Notes
                            (sort.isEmpty)
                                ? Center(
                                    child: Text(
                                      "Empty",
                                      style: fontStyle(
                                          size: 13, theme: widget.theme),
                                    ),
                                  )
                                : Column(
                                    children: sort.map((map) {
                                      // Model
                                      final PostEntity post =
                                          PostEntity.fromMap((map["doc"]
                                                  as DocumentSnapshot)
                                              .data() as Map<String, dynamic>);

                                      final NoteEntity? note =
                                          (post.note == null)
                                              ? null
                                              : NoteEntity.fromMap(post.note!);

                                      final RatingEntity? rating = (post
                                                  .rating ==
                                              null)
                                          ? null
                                          : RatingEntity.fromMap(post.rating!);

                                      final UserPollEntity? userPoll =
                                          (post.userPoll == null)
                                              ? null
                                              : UserPollEntity.fromMap(
                                                  post.userPoll!);

                                      return PostCardWidget(
                                        enableClick: true,
                                        post: post,
                                        userId: widget.userId,
                                        postId:
                                            (map['doc'] as DocumentSnapshot).id,
                                        note: note,
                                        rating: rating,
                                        userPoll: userPoll,
                                        theme: widget.theme,
                                        userAuth: widget.user,
                                      );
                                    }).toList(),
                                  ),
                          ],
                        ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Total notes: ${data.length}",
                                    style: fontStyle(
                                      size: 13,
                                      theme: widget.theme,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Dropdown
                                dropDownSort(),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Notes
                            (data.isEmpty)
                                ? Center(
                                    child: Text(
                                      "Empty",
                                      style: fontStyle(
                                          size: 13, theme: widget.theme),
                                    ),
                                  )
                                : Column(
                                    children: data.map((map) {
                                      // Model
                                      final PostEntity post =
                                          PostEntity.fromMap(map.data()
                                              as Map<String, dynamic>);

                                      final NoteEntity? note =
                                          (post.note == null)
                                              ? null
                                              : NoteEntity.fromMap(post.note!);

                                      final RatingEntity? rating = (post
                                                  .rating ==
                                              null)
                                          ? null
                                          : RatingEntity.fromMap(post.rating!);

                                      final UserPollEntity? userPoll =
                                          (post.userPoll == null)
                                              ? null
                                              : UserPollEntity.fromMap(
                                                  post.userPoll!);

                                      return PostCardWidget(
                                        enableClick: true,
                                        post: post,
                                        userId: widget.userId,
                                        postId: map.id,
                                        note: note,
                                        rating: rating,
                                        userPoll: userPoll,
                                        theme: widget.theme,
                                        userAuth: widget.user,
                                      );
                                    }).toList(),
                                  ),
                          ],
                        ),
                      ),
                    );
            },
          );
        });
  }
}
