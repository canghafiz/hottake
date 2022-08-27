import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';

Drawer drawer({
  required ThemeEntity theme,
  required BuildContext context,
  required String userId,
  required User user,
}) {
  return Drawer(
    backgroundColor: convertTheme(theme.primary),
    child: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Activity
            ListTile(
              onTap: () {
                // Navigate
                toActivityPage(context: context, userId: userId, user: user);
              },
              leading: Icon(
                Icons.history,
                color: convertTheme(theme.secondary),
              ),
              title: Text(
                "Activity",
                style: fontStyle(size: 15, theme: theme),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: convertTheme(theme.secondary),
                size: 16,
              ),
            ),
            // Settings
            ListTile(
              onTap: () {
                // Navigate
                toAppSettingPage(context: context, userId: userId);
              },
              leading: Icon(
                Icons.settings,
                color: convertTheme(theme.secondary),
              ),
              title: Text(
                "Settings",
                style: fontStyle(size: 15, theme: theme),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: convertTheme(theme.secondary),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
