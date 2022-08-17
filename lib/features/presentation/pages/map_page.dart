import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';
import 'package:hottake/main.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

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
  }) async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      onRadius ? redCardImage : greyCardImage,
    );

    setState(
      () {
        _markers.add(
          Marker(
            markerId: MarkerId(id),
            position: position,
            icon: icon,
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

                    if (distance(
                          current: LatLng(snapshot.data!.latitude,
                              snapshot.data!.longitude),
                          postLoc: LatLng(
                            double.parse(post.latitude),
                            double.parse(post.longitude),
                          ),
                        ) <=
                        radiusMap) {
                      updateMarkers(
                        onRadius: true,
                        position: LatLng(
                          double.parse(post.latitude),
                          double.parse(post.longitude),
                        ),
                        id: doc.id,
                      );
                    } else {
                      updateMarkers(
                        onRadius: false,
                        position: LatLng(
                          double.parse(post.latitude),
                          double.parse(post.longitude),
                        ),
                        id: doc.id,
                      );
                    }
                  }

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
                        fillColor: const Color(0xffFF5B58).withOpacity(0.3),
                        strokeColor: Colors.transparent,
                      ),
                    },
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        snapshot.data!.latitude,
                        snapshot.data!.longitude,
                      ),
                      zoom: 20,
                    ),
                    onMapCreated: (value) {
                      _controller.complete(value);
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
