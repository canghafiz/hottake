import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    // // Init
    initState(context: context, user: user);

    final pages = [
      HomePage(userId: user.uid, user: user),
      MapPage(
        userId: user.uid,
        postId: null,
        theme: dI<ThemeCubitEvent>().read(context).state,
        user: user,
      ),
      PostLocationPage(postId: null, userId: user.uid, user: user),
      FavouritesPage(userId: user.uid, user: user),
      UserPage(
        userId: user.uid,
        initialTab: 1,
        user: user,
        forOwn: true,
        initPage: true,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: BlocSelector<NavbarCubit, NavbarState, int>(
                selector: (state) => state.bottomNav,
                builder: (_, bottomNav) => Column(
                  children: [
                    // Top Nav
                    (bottomNav == 0)
                        ? const TopNavbarWidget()
                        : const SizedBox(),
                    // Pages
                    Expanded(
                      child: pages.elementAt(bottomNav),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Nav
            const BottomNavbarWidget(),
          ],
        ),
      ),
    );
  }
}
