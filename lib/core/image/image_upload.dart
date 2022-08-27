import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

Future<void> uploadPhotoProfile({
  required BuildContext context,
  required File file,
  required ThemeEntity theme,
  required String userId,
  required Function(String) database,
}) async {
  imageCrop(file: file, theme: theme).then((file) async {
    if (file != null) {
      // Update State
      dI<ImageCubitEvent>().read(context).updateUpload(true);

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
