import 'dart:async';

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

class PostLocationPage extends StatefulWidget {
  const PostLocationPage({
    Key? key,
    required this.postId,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final String? postId;
  final String userId;
  final User user;

  @override
  State<PostLocationPage> createState() => _PostLocationPageState();
}

class _PostLocationPageState extends State<PostLocationPage> {
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

  @override
  void initState() {
    super.initState();
    final state = dI<PostCubitEvent>().read(context).state;
    if (state.latitude == null && state.longitude == null) {
      getCurrentLocation(
        (value) {
          // Update State
          dI<PostCubitEvent>().read(context).updateLocation(
                latitude: value.latitude.toString(),
                longitude: value.longitude.toString(),
              );
        },
      );
    }
    if (widget.postId == null) {
      // Update State
      dI<PostCubitEvent>().read(context).clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        endDrawer: drawer(
          theme: theme,
          context: context,
          userId: widget.userId,
          user: widget.user,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Back Btn
                    (widget.postId == null)
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: convertTheme(theme.primary),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: convertTheme(theme.secondary),
                              ),
                            ),
                          ),
                    SizedBox(width: (widget.postId == null) ? 0 : 12),
                    // Title
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: convertTheme(theme.third),
                        ),
                        child: Text(
                          "Place the marker inside the circle area and create a post",
                          style: fontStyle(size: 13, theme: theme),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Btn Show Drawer
                    Builder(builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: Icon(
                          Icons.dehaze,
                          color: convertTheme(theme.secondary),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Map
              Expanded(
                child: BlocSelector<PostCubit, PostState, PostState>(
                  selector: (state) => state,
                  builder: (_, state) => (state.latitude == null &&
                          state.longitude == null)
                      ? Center(
                          child: CircularProgressIndicator(
                            color: convertTheme(theme.secondary),
                          ),
                        )
                      : FutureBuilder<BitmapDescriptor>(
                          future: BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            redCardImage,
                          ),
                          builder: (_, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: convertTheme(theme.secondary),
                                ),
                              );
                            }
                            return FutureBuilder<Position>(
                              future: getCurrentLocationAndReturn(),
                              builder: (_, yourLocation) {
                                if (!yourLocation.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: convertTheme(theme.secondary),
                                    ),
                                  );
                                }
                                return Stack(
                                  children: [
                                    GoogleMap(
                                      zoomControlsEnabled: false,
                                      myLocationButtonEnabled: false,
                                      markers: {
                                        Marker(
                                          markerId: const MarkerId('1'),
                                          position: LatLng(
                                            double.parse(state.latitude!),
                                            double.parse(state.longitude!),
                                          ),
                                          icon: snapshot.data!,
                                          infoWindow: const InfoWindow(
                                            title:
                                                "Move the pin to select location on map",
                                          ),
                                        ),
                                      },
                                      circles: {
                                        Circle(
                                          circleId: const CircleId("Radius"),
                                          center: LatLng(
                                            yourLocation.data!.latitude,
                                            yourLocation.data!.longitude,
                                          ),
                                          radius: 50,
                                          fillColor: convertTheme(
                                                  (themes[0] as ThemeEntity)
                                                      .third)
                                              .withOpacity(0.3),
                                          strokeColor: Colors.transparent,
                                        ),
                                      },
                                      myLocationEnabled: true,
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          double.parse(state.latitude!),
                                          double.parse(state.longitude!),
                                        ),
                                        zoom: 20,
                                      ),
                                      onMapCreated: (value) {
                                        _controller.complete(value);
                                        value.showMarkerInfoWindow(
                                          const MarkerId("1"),
                                        );
                                        mapStyle(
                                          isDark: (theme.primary ==
                                              (themes[0] as ThemeModel)
                                                  .primary),
                                          style: (style) {
                                            value.setMapStyle(style);
                                          },
                                        );
                                      },
                                      onCameraMove: (value) {
                                        if (locationOnRadius(
                                          current: LatLng(
                                            yourLocation.data!.latitude,
                                            yourLocation.data!.longitude,
                                          ),
                                          postLoc: LatLng(
                                            value.target.latitude,
                                            value.target.longitude,
                                          ),
                                          radius: 50,
                                        )) {
                                          // Update State
                                          dI<PostCubitEvent>()
                                              .read(context)
                                              .updateLocation(
                                                latitude: value.target.latitude
                                                    .toString(),
                                                longitude: value
                                                    .target.longitude
                                                    .toString(),
                                              );
                                        }
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
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            color: convertTheme(theme.third),
                                          ),
                                          child: Text(
                                            "Radius 50 Meter",
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
              // Btn Select Location
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButtonText(
                  onTap: () {
                    // Navigate
                    toPostCreatorPage(
                      context: context,
                      userId: widget.userId,
                      postId: widget.postId,
                      user: widget.user,
                    );
                  },
                  themeEntity: theme,
                  text: "Select Location",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
