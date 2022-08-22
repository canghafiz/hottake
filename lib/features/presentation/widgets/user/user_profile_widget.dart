// ignore_for_file: unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/core/firebase/firestore/user_firestore.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    Key? key,
    required this.userId,
    required this.theme,
    required this.forOwn,
  }) : super(key: key);
  final String userId;
  final ThemeEntity theme;
  final bool forOwn;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: dI<UserFirestore>().getRealTimeUser(userId),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  "Loading...",
                  style: fontStyle(
                    size: 13,
                    theme: theme,
                  ),
                ),
              );
            } else {
              if (snapshot.data!.data() != null) {
                // Model
                final UserEntity user = UserEntity.fromMap(
                    snapshot.data!.data() as Map<String, dynamic>);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    // Btn Edit
                    !forOwn
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate
                                toEditUserPage(
                                  context: context,
                                  userId: userId,
                                  user: user,
                                );
                              },
                              child: Text(
                                "Edit Profile",
                                style: fontStyle(size: 11, theme: theme),
                              ),
                            ),
                          ),
                    // Photo Profile
                    PhotoProfileWidget(
                      url: user.photo,
                      size: 56,
                      theme: theme,
                    ),
                    const SizedBox(height: 16),
                    // Username
                    Text(
                      "@" + user.username,
                      style: fontStyle(
                        size: 13,
                        theme: theme,
                        weight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Bio
                    Text(
                      user.bio ?? "YOUR BIO IS EMPTY!",
                      style: fontStyle(size: 9, theme: theme),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    // Social Media Link
                    ActionChip(
                      backgroundColor: convertTheme(theme.secondary),
                      label: Text(
                        user.socialMedia ?? "YOUR SOCIAL MEDIA LINK IS EMPTY!",
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: convertTheme(theme.primary),
                          decoration: (user.socialMedia != null)
                              ? TextDecoration.underline
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        if (user.socialMedia != null) {
                          launchUrlString(user.socialMedia!);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }
          },
        ),
      ),
    );
  }
}
