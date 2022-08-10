import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class TextfieldPostWidget extends StatelessWidget {
  const TextfieldPostWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.theme,
    required this.validator,
    required this.type,
    this.maxLine,
  }) : super(key: key);
  final TextEditingController controller;
  final Function(String?) validator;
  final ThemeEntity theme;
  final TextInputType type;
  final String hintText;
  final double? maxLine;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24 * (maxLine ?? 2),
      child: TextFormFieldCustom(
        controller: controller,
        inputType: type,
        validator: validator,
        hintText: hintText,
        themeEntity: theme,
        maxLine: maxLine?.toInt(),
      ),
    );
  }
}
