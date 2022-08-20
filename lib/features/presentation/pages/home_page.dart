import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    List<Widget> components(ThemeEntity theme) {
      return [
        PostNearbyWidget(userId: userId, theme: theme, user: user),
        MapPage(userId: userId, postId: null, theme: theme, user: user),
        FavouritesPage(userId: userId, user: user),
      ];
    }

    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        body: BlocSelector<NavbarCubit, NavbarState, int>(
          selector: (state) => state.topNav,
          builder: (_, state) => components(theme).elementAt(state),
        ),
      ),
    );
  }
}
