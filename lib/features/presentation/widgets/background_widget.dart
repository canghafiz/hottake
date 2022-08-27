import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

Widget backgroundWidget({
  required BuildContext context,
  required String? urlAsset,
  required Widget mainContent,
  Color? gradientColor,
}) {
  return SizedBox(
    width: double.infinity,
    height: MediaQuery.of(context).size.height,
    child: Stack(
      children: [
        // Main Bg
        Image.asset(
          patternWhiteImage,
          fit: BoxFit.fitHeight,
          width: double.infinity,
          height: double.infinity,
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: convertTheme(dI<ThemeCubitEvent>().read(context).state.primary)
              .withOpacity(0.9),
        ),
        (urlAsset == null)
            ? const SizedBox()
            : Align(
                alignment: (gradientColor == null)
                    ? Alignment.bottomCenter
                    : Alignment.center,
                child: Image.asset(
                  urlAsset,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
        (urlAsset == null)
            ? const SizedBox()
            : Container(
                width: double.infinity,
                height: double.infinity,
                color: convertTheme(
                        dI<ThemeCubitEvent>().read(context).state.primary)
                    .withOpacity((gradientColor != null) ? 0 : 0.5),
              ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  (gradientColor == null)
                      ? Colors.transparent
                      : gradientColor.withOpacity(0.6),
                  (gradientColor == null)
                      ? Colors.transparent
                      : gradientColor.withOpacity(0.6),
                ],
              ),
            ),
          ),
        ),
        // Main
        SafeArea(child: mainContent),
      ],
    ),
  );
}
