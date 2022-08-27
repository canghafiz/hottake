import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PhotoUploadBar extends StatelessWidget {
  const PhotoUploadBar({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlocSelector<ImageCubit, ImageState, bool>(
        selector: (state) => state.onUpload,
        builder: (context, onUpload) => onUpload
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.blue,
                child: Text(
                  "Image is uploading...",
                  style: fontStyle(
                    size: 13,
                    theme: theme,
                    color: Colors.white,
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
