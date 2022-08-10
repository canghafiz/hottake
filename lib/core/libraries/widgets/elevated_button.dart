import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class ElevatedButtonText extends StatelessWidget {
  const ElevatedButtonText({
    Key? key,
    required this.onTap,
    required this.themeEntity,
    required this.text,
    this.btnColor,
    this.textColor,
    this.height,
    this.width,
  }) : super(key: key);
  final Function onTap;
  final ThemeEntity themeEntity;
  final String text;
  final Color? btnColor, textColor;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(),
      child: Text(
        text,
        style: fontStyle(
          size: 13,
          theme: themeEntity,
          color: textColor,
          weight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          width ?? double.infinity,
          height ?? 48,
        ),
        primary: btnColor ?? convertTheme(themeEntity.third),
        maximumSize: Size(
          width ?? double.infinity,
          height ?? 48,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
      ),
    );
  }
}

class ElevatedButtonTextWithIcon extends StatelessWidget {
  const ElevatedButtonTextWithIcon({
    Key? key,
    required this.onTap,
    required this.themeEntity,
    required this.text,
    required this.icon,
    this.btnColor,
    this.textColor,
    this.height,
    this.width,
  }) : super(key: key);
  final Function onTap;
  final ThemeEntity themeEntity;
  final Widget icon;
  final String text;
  final Color? btnColor, textColor;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => onTap(),
      icon: icon,
      label: Text(
        text,
        style: fontStyle(
          size: 13,
          theme: themeEntity,
          color: textColor,
          weight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          width ?? double.infinity,
          height ?? 48,
        ),
        primary: btnColor ?? convertTheme(themeEntity.third),
        maximumSize: Size(
          width ?? double.infinity,
          height ?? 48,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
      ),
    );
  }
}
