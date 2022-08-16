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
  }) : super(key: key);
  final int? initialTab;
  final String userId;

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
            actions: [
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
              tabs: const [
                Tab(text: "My Profile"),
                Tab(text: "My Notes"),
              ],
            ),
            backgroundColor: convertTheme(theme.primary),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          body: TabBarView(
            children: [
              UserProfileWidget(userId: userId, theme: theme),
              UserNotesWidget(userId: userId, theme: theme),
            ],
          ),
        ),
      ),
    );
  }
}
