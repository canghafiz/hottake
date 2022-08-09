import 'dart:io';

import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

Future<void> uploadPhotoProfile({
  required File file,
  required ThemeEntity theme,
  required String userId,
  required Function(String) database,
}) async {
  imageCrop(file: file, theme: theme).then((file) async {
    if (file != null) {
      await uploadImageToStorage(
        folderName: "Photo Profile",
        fileName: userId,
        file: file,
      ).then(
        (url) =>
            // Call Database
            database.call(url),
      );
    }
  });
}
