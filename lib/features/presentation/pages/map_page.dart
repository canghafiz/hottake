import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/data/data.dart';
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

  void _currentLocation() async {
    await getCurrentLocationAndReturn().then(
      (position) {
        _controller.future.then(
          (controller) {
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: 0,
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 20,
                ),
              ),
            );
          },
        );
      },
    );
  }

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
    required ThemeEntity theme,
  }) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      onRadius
          ? (post.reads.contains(widget.userId))
              ? greyCardImage
              : redCardImage
          : outlineCardImage,
    );

    setState(
      () {
        _markers.add(
          Marker(
            onTap: () {
              if (onRadius) {
                // Update Data
                dI<UpdateReadPost>().call(
                  postId: id,
                  userId: widget.userId,
                );

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
              } else {
                // Show Dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return textDialog(
                      text:
                          "The note is outside your viewing radius.Try getting closer! (open in Google maps)",
                      size: 13,
                      color: convertTheme(theme.third),
                      align: TextAlign.center,
                    );
                  },
                );
              }
            },
            markerId: MarkerId(id),
            position: position,
            icon: icon,
            infoWindow: const InfoWindow(
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
        extendBodyBehindAppBar: true,
        endDrawer: drawer(
          theme: theme,
          context: context,
          userId: widget.userId,
          user: widget.user,
        ),
        appBar: AppBar(
          leading: (widget.postId == null)
              ? null
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: convertTheme(theme.secondary),
                  ),
                ),
          title: Text(
            "Map",
            style: fontStyle(size: 17, theme: theme),
          ),
          iconTheme: IconThemeData(color: convertTheme(theme.secondary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
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
                        theme: theme,
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
                        theme: theme,
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

                  return Stack(
                    children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
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
                                convertTheme((themes[0] as ThemeEntity).third)
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
                            value.showMarkerInfoWindow(
                              MarkerId(
                                widget.postId!,
                              ),
                            );
                          }

                          mapStyle(
                            isDark: (theme.primary ==
                                (themes[0] as ThemeModel).primary),
                            style: (style) {
                              value.setMapStyle(style);
                            },
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16,
                            right: 16,
                          ),
                          child: FloatingActionButton(
                            onPressed: () {
                              _currentLocation();
                            },
                            child: Icon(
                              Icons.location_on,
                              color: convertTheme(theme.primary),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: convertTheme(theme.third),
                            ),
                            child: Text(
                              "Radius 5 KM",
                              style: fontStyle(
                                size: 11,
                                theme: theme,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
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
