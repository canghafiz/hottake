import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

Widget _roundedDialog(Widget content) {
  return Dialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: content,
    ),
  );
}

Widget textDialog({
  required String text,
  required double size,
  required Color color,
  required TextAlign? align,
}) {
  return _roundedDialog(
    BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Text(
        text,
        style: fontStyle(
          size: size,
          color: color,
          theme: theme,
        ),
        textAlign: align,
      ),
    ),
  );
}

Widget alertDialogWithCustomContent(Widget content) {
  return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
    selector: (state) => state,
    builder: (_, theme) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        content: content,
      );
    },
  );
}

Widget alertDialogTextWith2Button({
  required String text,
  required double fontSize,
  required Color fontColor,
  required Function onfalse,
  required Function onTrue,
  required String onFalseText,
  required String onTrueText,
}) {
  return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) {
        return AlertDialog(
          backgroundColor: convertTheme(theme.primary),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          content: Text(
            text,
            style: fontStyle(
              size: fontSize,
              color: fontColor,
              theme: theme,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            // Yes
            ElevatedButton(
              onPressed: () => onTrue(),
              child: Text(
                onTrueText,
                style: fontStyle(
                  size: fontSize,
                  theme: theme,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                primary: convertTheme(theme.third),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),
            // Cancel
            ElevatedButton(
              onPressed: () => onfalse(),
              child: Text(
                onFalseText,
                style: fontStyle(
                  size: fontSize,
                  theme: theme,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                primary: Colors.transparent,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),
          ],
        );
      });
}
