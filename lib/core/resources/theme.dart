import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:sizer/sizer.dart';

ThemeData appTheme({
  required BuildContext context,
  required ThemeEntity theme,
}) {
  return ThemeData(
    fontFamily: "Poppins",
    scaffoldBackgroundColor: convertTheme(theme.primary),
    colorScheme: const ColorScheme.light().copyWith(
      primary: convertTheme(theme.primary),
      secondary: convertTheme(theme.secondary),
      tertiary: convertTheme(theme.third),
    ),
    unselectedWidgetColor: Colors.grey,
  );
}

// Text Style
TextStyle fontStyle({
  required double size,
  Color? color,
  FontWeight? weight,
  required ThemeEntity theme,
}) {
  return TextStyle(
    fontSize: size.sp,
    color: color ?? convertTheme(theme.secondary),
    fontWeight: weight,
  );
}
