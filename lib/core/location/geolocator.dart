import 'package:geolocator/geolocator.dart';

Future<void> getCurrentLocation(Function(Position) position) async {
  await Geolocator.getCurrentPosition().then((value) => position.call(value));
}

Future<Position> getCurrentLocationAndReturn() async {
  return await Geolocator.getCurrentPosition();
}

Future<bool> locationPermission() async {
  final permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied) {
    return false;
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}
