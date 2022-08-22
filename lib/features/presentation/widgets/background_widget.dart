import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

Widget backgroundWidget({
  required BuildContext context,
  required String? urlAsset,
  required Widget mainContent,
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
                alignment: Alignment.bottomCenter,
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
                    .withOpacity(0.3),
              ),
        // Main
        SafeArea(child: mainContent),
      ],
    ),
  );
}
