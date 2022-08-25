import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PhotoCreateWidget extends StatelessWidget {
  const PhotoCreateWidget({
    Key? key,
    required this.userId,
    required this.theme,
  }) : super(key: key);
  final String userId;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 36),
            // Title
            Text(
              "Choose a Profile Pic",
              style: fontStyle(
                size: 17,
                theme: theme,
                weight: FontWeight.w500,
              ),
            ),
            // Subtitle
            Text(
              "Oh hey there!",
              style: fontStyle(
                size: 13,
                theme: theme,
              ),
            ),
            const SizedBox(height: 16),
            // Photo
            Center(
              child: EditUserPhotoProfileWidget(userId: userId, theme: theme),
            ),
            const SizedBox(height: 16),
            // Btn Ok
            ElevatedButtonText(
              onTap: () {
                dI<UserFirestore>().checkPhotoProfile(
                  userId: userId,
                  empty: () {
                    // Show Dialog
                    showDialog(
                      context: context,
                      builder: (context) => alertDialogTextWith2Button(
                        text: "Are you sure leave your photo profile is blank?",
                        fontSize: 13,
                        fontColor: convertTheme(theme.third),
                        onfalse: () {
                          Navigator.pop(context);
                        },
                        onTrue: () {
                          Navigator.pop(context);
                          // Update Data
                          dI<UserUpdatePhoto>().call(userId: userId, url: null);
                          // Update State
                          dI<CreateAccountCubitEvent>()
                              .read(context)
                              .updatePage(true);
                        },
                        onFalseText: "No",
                        onTrueText: "Yes",
                      ),
                    );
                  },
                  notEmpty: () {
                    // Update State
                    dI<CreateAccountCubitEvent>()
                        .read(context)
                        .updatePage(true);
                  },
                );
              },
              themeEntity: theme,
              text: "Ok",
            ),
          ],
        ),
      ),
    );
  }
}
