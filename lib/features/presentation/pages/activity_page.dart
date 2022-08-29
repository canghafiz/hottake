import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({
    Key? key,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final String userId;
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: convertTheme(theme.secondary),
              ),
            ),
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
              tabs: const [
                Tab(text: "My Notes"),
                Tab(text: "Notifications"),
              ],
            ),
            backgroundColor: convertTheme(theme.primary),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          body: TabBarView(
            children: [
              UserNotesWidget(userId: userId, theme: theme, user: user),
              NotificationPage(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
