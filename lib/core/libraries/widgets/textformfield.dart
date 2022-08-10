import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    Key? key,
    required this.controller,
    required this.inputType,
    required this.validator,
    required this.hintText,
    required this.themeEntity,
    this.obscureText,
    this.textColor,
    this.borderColor,
    this.prefix,
    this.maxLine,
  }) : super(key: key);
  final TextEditingController controller;
  final TextInputType inputType;
  final Function(String?) validator;
  final Color? borderColor, textColor;
  final String hintText;
  final bool? obscureText;
  final Widget? prefix;
  final ThemeEntity themeEntity;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    final borderWhenActive = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      borderSide: BorderSide(
        color: borderColor ?? convertTheme(themeEntity.third),
        width: 3,
      ),
    );

    final borderWhenInActive = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      borderSide: BorderSide(
        color: borderColor ?? convertTheme(themeEntity.third),
      ),
    );

    final textStyle = fontStyle(
      size: 11,
      theme: themeEntity,
      color: textColor,
    );

    final errorStyle = fontStyle(
      size: 12,
      theme: themeEntity,
      color: convertTheme(themeEntity.third),
    );

    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: (value) => validator(value),
      obscureText: obscureText ?? false,
      style: textStyle,
      cursorColor: textStyle.color,
      maxLines: maxLine ?? 1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8),
        focusedBorder: borderWhenActive,
        border: borderWhenInActive,
        enabledBorder: borderWhenInActive,
        disabledBorder: borderWhenInActive,
        errorBorder: borderWhenActive,
        focusedErrorBorder: borderWhenActive,
        hintText: hintText,
        hintStyle: textStyle,
        errorStyle: errorStyle,
        prefix: prefix,
      ),
    );
  }
}
