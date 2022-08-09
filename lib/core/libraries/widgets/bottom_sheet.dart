import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

void showModalBottom({
  required BuildContext context,
  required Widget content,
  required ThemeEntity theme,
}) {
  showModalBottomSheet(
    backgroundColor: convertTheme(theme.primary),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    context: context,
    builder: (context) => content,
  );
}

Widget bottomSheetContent(List<Widget> contents) {
  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: contents,
    ),
  );
}
