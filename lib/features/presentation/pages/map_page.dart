import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
    required this.userId,
    required this.postId,
    required this.theme,
    required this.user,
  }) : super(key: key);
  final String userId;
  final String? postId;
  final ThemeEntity theme;
  final User user;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  // ignore: prefer_final_fields
  Set<Marker> _markers = {};

  void updateMarkers({
    required bool onRadius,
    required LatLng position,
    required String id,
    required PostEntity post,
    required NoteEntity? note,
    required RatingEntity? rating,
    required UserPollEntity? userPoll,
  }) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      onRadius ? redCardImage : greyCardImage,
    );

    setState(
      () {
        _markers.add(
          Marker(
            onTap: () {
              // Show Modal Bottom
              showModalBottom(
                context: context,
                content: postDetailWidget(
                  userId: widget.userId,
                  postId: id,
                  post: post,
                  note: note,
                  rating: rating,
                  userPoll: userPoll,
                  theme: widget.theme,
                  user: widget.user,
                ),
                theme: widget.theme,
              );
            },
            markerId: MarkerId(id),
            position: position,
            icon: icon,
            infoWindow: (widget.postId == null)
                ? InfoWindow.noText
                : (id != widget.postId)
                    ? InfoWindow.noText
                    : const InfoWindow(
                        title: "The Post Is Here",
                      ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: dI<PostFirestore>().getNotes(),
            builder: (_, all) {
              if (!all.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: convertTheme(theme.secondary),
                  ),
                );
              }

              return FutureBuilder<Position>(
                future: getCurrentLocationAndReturn(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: convertTheme(theme.secondary),
                      ),
                    );
                  }

                  for (DocumentSnapshot doc in all.data!.docs) {
                    // Model
                    final PostEntity post =
                        PostEntity.fromMap(doc.data() as Map<String, dynamic>);

                    final NoteEntity? note = (post.note == null)
                        ? null
                        : NoteEntity.fromMap(post.note!);

                    final RatingEntity? rating = (post.rating == null)
                        ? null
                        : RatingEntity.fromMap(post.rating!);

                    final UserPollEntity? userPoll = (post.userPoll == null)
                        ? null
                        : UserPollEntity.fromMap(post.userPoll!);

                    if (locationOnRadius(
                      current: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                      postLoc: LatLng(
                        double.parse(post.latitude),
                        double.parse(post.longitude),
                      ),
                    )) {
                      updateMarkers(
                        onRadius: true,
                        position: LatLng(
                          double.parse(post.latitude),
                          double.parse(post.longitude),
                        ),
                        id: doc.id,
                        note: note,
                        post: post,
                        rating: rating,
                        userPoll: userPoll,
                      );
                    } else {
                      updateMarkers(
                        onRadius: false,
                        position: LatLng(
                          double.parse(post.latitude),
                          double.parse(post.longitude),
                        ),
                        id: doc.id,
                        note: note,
                        post: post,
                        rating: rating,
                        userPoll: userPoll,
                      );
                    }
                  }

                  final PostEntity? post = (widget.postId == null)
                      ? null
                      : PostEntity.fromMap(all
                          .data!
                          .docs[all.data!.docs
                              .indexWhere((doc) => doc.id == widget.postId!)]
                          .data() as Map<String, dynamic>);

                  return GoogleMap(
                    markers: _markers,
                    circles: {
                      Circle(
                        circleId: const CircleId("Radius"),
                        center: LatLng(
                          snapshot.data!.latitude,
                          snapshot.data!.longitude,
                        ),
                        radius: radiusMap,
                        fillColor:
                            convertTheme((themes[3] as ThemeEntity).primary)
                                .withOpacity(0.3),
                        strokeColor: Colors.transparent,
                      ),
                    },
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        (post != null)
                            ? double.parse(post.latitude)
                            : snapshot.data!.latitude,
                        (post != null)
                            ? double.parse(post.longitude)
                            : snapshot.data!.longitude,
                      ),
                      zoom: (widget.postId != null) ? 50 : 10,
                    ),
                    onMapCreated: (value) {
                      _controller.complete(value);

                      if (widget.postId != null) {
                        value
                            .isMarkerInfoWindowShown(MarkerId(widget.postId!))
                            .then(
                          (show) {
                            if (!show) {
                              value.showMarkerInfoWindow(
                                MarkerId(
                                  widget.postId!,
                                ),
                              );
                            }
                          },
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
