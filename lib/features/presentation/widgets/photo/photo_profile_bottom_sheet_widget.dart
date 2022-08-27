import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

Widget photoProfileBottomSheetWidget({
  required BuildContext context,
  required String userId,
  required String? url,
  required ThemeEntity theme,
}) {
  return bottomSheetContent(
    [
      // From Gallery
      ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          dI<ImagePickerService>().fromGallery().then(
            (file) {
              if (file != null) {
                // Call Services
                uploadPhotoProfile(
                  context: context,
                  file: file,
                  theme: theme,
                  userId: userId,
                  database: (url) {
                    // Update State
                    dI<ImageCubitEvent>().read(context).updateUpload(false);

                    // Update Data
                    dI<UserUpdatePhoto>().call(
                      userId: userId,
                      url: url,
                    );

                    // Show Dialog
                    showDialog(
                      context: context,
                      builder: (context) => textDialog(
                        text: "Image is updated",
                        size: 13,
                        color: Colors.green,
                        align: TextAlign.center,
                      ),
                    );
                  },
                );
              }
            },
          );
        },
        title: Text(
          "Pick from gallery",
          style: fontStyle(size: 13, theme: theme),
        ),
        trailing: Icon(
          Icons.wallpaper,
          color: convertTheme(theme.secondary),
        ),
      ),
      // From Camera
      ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          dI<ImagePickerService>().fromCamera().then(
            (file) {
              if (file != null) {
                uploadPhotoProfile(
                  context: context,
                  file: file,
                  theme: theme,
                  userId: userId,
                  database: (url) {
                    // Update State
                    dI<ImageCubitEvent>().read(context).updateUpload(false);

                    // Update Data
                    dI<UserUpdatePhoto>().call(
                      userId: userId,
                      url: url,
                    );

                    // Show Dialog
                    showDialog(
                      context: context,
                      builder: (context) => textDialog(
                        text: "Image is updated",
                        size: 13,
                        color: Colors.green,
                        align: TextAlign.center,
                      ),
                    );
                  },
                );
              }
            },
          );
        },
        title: Text(
          "Pick from camera",
          style: fontStyle(size: 13, theme: theme),
        ),
        trailing: Icon(
          Icons.camera_alt_outlined,
          color: convertTheme(theme.secondary),
        ),
      ),
      // Delete
      (url != null)
          ? ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                deleteImageFromStorage(url).then(
                  (_) =>
                      // Update Data
                      dI<UserUpdatePhoto>().call(
                    userId: userId,
                    url: null,
                  ),
                );
              },
              title: Text(
                "Delete",
                style: fontStyle(size: 13, theme: theme),
              ),
              trailing: Icon(
                Icons.delete_outline,
                color: convertTheme(theme.secondary),
              ),
            )
          : const SizedBox(),
    ],
  );
}
