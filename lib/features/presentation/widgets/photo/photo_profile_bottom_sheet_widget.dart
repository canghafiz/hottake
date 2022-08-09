import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';

class PhotoProfileBottomSheetWidget extends StatelessWidget {
  const PhotoProfileBottomSheetWidget({
    Key? key,
    required this.url,
    required this.theme,
    required this.userId,
  }) : super(key: key);
  final String userId;
  final String? url;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
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
                  uploadPhotoProfile(
                    file: file,
                    theme: theme,
                    userId: userId,
                    database: (url) {
                      // Update Data
                      dI<UserUpdatePhoto>().call(
                        userId: userId,
                        url: url,
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
                    file: file,
                    theme: theme,
                    userId: userId,
                    database: (url) {
                      // Update Data
                      dI<UserUpdatePhoto>().call(
                        userId: userId,
                        url: url,
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
                  deleteImageFromStorage(url!).then(
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
}
