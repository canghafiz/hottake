import 'dart:io';

import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> imageCrop({
  required File file,
  required ThemeEntity theme,
}) async {
  return await ImageCropper().cropImage(
    sourcePath: file.path,
    aspectRatioPresets: Platform.isAndroid
        ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]
        : [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Edit Photo',
        toolbarColor: convertTheme(theme.primary),
        toolbarWidgetColor: convertTheme(theme.secondary),
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        activeControlsWidgetColor: convertTheme(theme.secondary),
      ),
      IOSUiSettings(
        title: 'Edit Photo',
      ),
    ],
  ).then((value) {
    if (value != null) {
      return File(value.path);
    }
    return null;
  });
}
