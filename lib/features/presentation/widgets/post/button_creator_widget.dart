import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class ButtonCreatorWidget extends StatelessWidget {
  const ButtonCreatorWidget({
    Key? key,
    required this.onTap,
    required this.title,
    required this.theme,
  }) : super(key: key);
  final String title;
  final Function onTap;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonText(
      onTap: () => onTap(),
      themeEntity: theme,
      text: title,
      width: 100,
      height: 36,
    );
  }
}
