import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PostLocationPage extends StatefulWidget {
  const PostLocationPage({
    Key? key,
    required this.postId,
    required this.userId,
  }) : super(key: key);
  final String? postId;
  final String userId;

  @override
  State<PostLocationPage> createState() => _PostLocationPageState();
}

class _PostLocationPageState extends State<PostLocationPage> {
  final Completer<GoogleMapController> _controller = Completer();

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: convertTheme(theme.secondary),
            ),
          ),
          title: Text(
            "Select Location",
            style: fontStyle(size: 15, theme: theme),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
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
                          return GoogleMap(
                            markers: {
                              Marker(
                                markerId: const MarkerId('1'),
                                position: LatLng(double.parse(state.latitude!),
                                    double.parse(state.longitude!)),
                                icon: snapshot.data!,
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
                            },
                            onCameraMove: (value) {
                              // Update State
                              dI<PostCubitEvent>().read(context).updateLocation(
                                    latitude: value.target.latitude.toString(),
                                    longitude:
                                        value.target.longitude.toString(),
                                  );
                            },
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // Btn Next
            ButtonCreatorWidget(
                onTap: () {
                  // Navigate
                  toPostCreatorPage(
                    context: context,
                    userId: widget.userId,
                    postId: widget.postId,
                  );
                },
                title: "Next",
                theme: theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
