import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.userId,
    required this.note,
    required this.theme,
  }) : super(key: key);
  final String userId;
  final NoteEntity note;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          note.title,
          style: fontStyle(
            size: 13,
            theme: theme,
            weight: FontWeight.bold,
          ),
        ),
        // Note
        Text(
          note.note,
          style: fontStyle(
            size: 13,
            theme: theme,
            color: convertTheme(theme.secondary).withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
