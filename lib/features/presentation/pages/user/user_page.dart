import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class UserPage extends StatelessWidget {
  const UserPage({
    Key? key,
    this.initialTab,
    required this.userId,
    required this.user,
    required this.forOwn,
    required this.initPage,
  }) : super(key: key);
  final int? initialTab;
  final String userId;
  final User user;
  final bool forOwn, initPage;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => DefaultTabController(
        length: 2,
        initialIndex: initialTab ?? 0,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: initPage
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: convertTheme(theme.secondary),
                    ),
                  ),
            actions: !forOwn
                ? null
                : [
                    PopupMenuButton(
                      color: convertTheme(theme.primary),
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: convertTheme(theme.secondary),
                      ),
                      onSelected: (value) {
                        if (value == 0) {
                          dI<AuthImpl>().logout(
                            context: context,
                            theme: theme,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: Text(
                            "Sign Out",
                            style: fontStyle(
                              size: 11,
                              theme: theme,
                              color: convertTheme(theme.secondary),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
            bottom: TabBar(
              labelStyle: fontStyle(
                size: 13,
                theme: theme,
                weight: FontWeight.w500,
              ),
              labelColor: convertTheme(theme.secondary),
              unselectedLabelColor:
                  convertTheme(theme.secondary).withOpacity(0.5),
              indicatorColor: convertTheme(theme.secondary),
              indicatorWeight: 5,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              tabs: [
                Tab(text: forOwn ? "My Profile" : "User Profile"),
                Tab(text: forOwn ? "My Notes" : "User Notes"),
              ],
            ),
            backgroundColor: convertTheme(theme.primary),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          body: TabBarView(
            children: [
              UserProfileWidget(userId: userId, theme: theme, forOwn: forOwn),
              UserNotesWidget(userId: userId, theme: theme, user: user),
            ],
          ),
        ),
      ),
    );
  }
}
