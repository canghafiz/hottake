import 'package:flutter/cupertino.dart';
import 'package:hottake/features/data/data.dart';

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
