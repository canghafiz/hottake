import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({
    Key? key,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final String userId;
  final User user;

  @override
  Widget build(BuildContext context) {
    // // Update State
    initState(context: context, userId: userId);

    // Update Date
    dI<UserFirestore>().checkIsUserAvailable(
      userId: userId,
      not: () {
        dI<UserCreateAccount>().call(
          userId: userId,
          email: user.email!,
          username: user.displayName ?? user.email!,
          photo: user.photoURL,
          bio: null,
          socialMedia: null,
          theme: dI<ThemeCubitEvent>().read(context).state,
        );
      },
    );

    final pages = [
      HomePage(userId: userId, user: user),
      MapPage(
        userId: userId,
        postId: null,
        theme: dI<ThemeCubitEvent>().read(context).state,
        user: user,
      ),
      PostLocationPage(postId: null, userId: userId, user: user),
      FavouritesPage(userId: userId, user: user),
      UserPage(
        userId: userId,
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
