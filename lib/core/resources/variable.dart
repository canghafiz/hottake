import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hottake/features/data/data.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

const keyTheme = "Theme";

List themes = [
  ThemeModel(primary: "2EB9B0", secondary: "FFFFFF", third: "000000"),
  ThemeModel(primary: "1E97CB", secondary: "FFFFFF", third: "000000"),
  ThemeModel(primary: "260F53", secondary: "FFFFFF", third: "FF5B58"),
  ThemeModel(primary: "FF5B58", secondary: "FFFFFF", third: "000000"),
  ThemeModel(primary: "424242", secondary: "FFFFFF", third: "FF5B58"),
  ThemeModel(primary: "DDDDDD", secondary: "000000", third: "FF5B58"),
];

Color convertTheme(String value) {
  return Color(int.parse("0xff$value"));
}

String convertTime(DateTime time) {
  return "${time.year}-${(time.month.toString().length < 2) ? "0${time.month}" : time.month}-${(time.day.toString().length < 2) ? "0${time.day}" : time.day} ${(time.hour.toString().length < 2) ? "0${time.hour}" : time.hour}:${(time.minute.toString().length < 2) ? "0${time.minute}" : time.minute}:${(time.second.toString().length < 2) ? "0${time.second}" : time.second}";
}

String time(String time) {
  final DateTime dateTime = DateFormat("yyyy-MM-dd").parse(time);
  String month = "";

  if (dateTime.month == 1) {
    month = "January";
  } else if (dateTime.month == 2) {
    month = "February";
  } else if (dateTime.month == 3) {
    month = "March";
  } else if (dateTime.month == 4) {
    month = "April";
  } else if (dateTime.month == 5) {
    month = "May";
  } else if (dateTime.month == 6) {
    month = "June";
  } else if (dateTime.month == 7) {
    month = "July";
  } else if (dateTime.month == 8) {
    month = "August";
  } else if (dateTime.month == 9) {
    month = "September";
  } else if (dateTime.month == 10) {
    month = "October";
  } else if (dateTime.month == 11) {
    month = "November";
  } else {
    month = "December";
  }

  return "${dateTime.day} $month ${dateTime.year}";
}

String timeDuration(String value) {
  return Jiffy(value, "yyyy-MM-dd hh:mm:ss").fromNow();
}

const double radiusMap = 100;

bool locationOnRadius({required LatLng current, required LatLng postLoc}) {
  final double location = Geolocator.distanceBetween(
    current.latitude,
    current.longitude,
    postLoc.latitude,
    postLoc.longitude,
  );

  if (location <= radiusMap) {
    return true;
  }
  return false;
}

int distanceAway({
  required LatLng firstPosition,
  required LatLng secondPosition,
}) {
  return Geolocator.distanceBetween(
    firstPosition.latitude,
    firstPosition.longitude,
    secondPosition.latitude,
    secondPosition.longitude,
  ).toInt();
}
