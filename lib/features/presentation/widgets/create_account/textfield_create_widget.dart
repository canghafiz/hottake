import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class TextfieldCreateWidget extends StatelessWidget {
  const TextfieldCreateWidget({
    Key? key,
    this.maxLength,
    required this.controller,
    required this.theme,
  }) : super(key: key);
  final int? maxLength;
  final TextEditingController controller;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    final borderWhenActive = UnderlineInputBorder(
      borderSide: BorderSide(
        color: convertTheme(theme.secondary),
        width: 3,
      ),
    );

    final borderWhenInActive = UnderlineInputBorder(
      borderSide: BorderSide(
        color: convertTheme(theme.secondary),
      ),
    );

    final textStyle = fontStyle(
      size: 13,
      theme: theme,
    );

    final errorStyle = fontStyle(
      size: 13,
      theme: theme,
    );
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "Must be filled";
        }
        return null;
      },
      style: textStyle,
      cursorColor: textStyle.color,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          bottom: 16,
        ),
        focusedBorder: borderWhenActive,
        border: borderWhenInActive,
        enabledBorder: borderWhenInActive,
        disabledBorder: borderWhenInActive,
        errorBorder: borderWhenActive,
        focusedErrorBorder: borderWhenActive,
        errorStyle: errorStyle,
      ),
    );
  }
}
