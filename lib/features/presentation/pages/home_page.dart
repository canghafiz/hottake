import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class HomePage extends StatelessWidget {
  const HomePage({
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
      builder: (_, theme) => Scaffold(
        backgroundColor: backgroundColor(theme),
        endDrawer: drawer(
          theme: theme,
          context: context,
          userId: userId,
          user: user,
        ),
        appBar: AppBar(
          title: Text(
            "Home",
            style: fontStyle(size: 17, theme: theme),
          ),
          iconTheme: IconThemeData(color: convertTheme(theme.secondary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: PostNearbyWidget(userId: userId, theme: theme, user: user),
      ),
    );
  }
}
