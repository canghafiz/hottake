import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    List<Widget> components(ThemeEntity theme) {
      return [
        PostNearbyWidget(userId: userId, theme: theme),
        MapPage(userId: userId, postId: null, theme: theme),
        FavouritesPage(userId: userId),
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
