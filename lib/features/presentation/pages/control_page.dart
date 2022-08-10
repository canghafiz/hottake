import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/features/presentation/presentation.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    // // Update State
    // clearState(context);
    initState(context: context, userId: userId);

    final pages = [
      HomePage(userId: userId),
      MapPage(userId: userId),
      PostChoosePage(userId: userId),
      FavouritesPage(userId: userId),
      UserPage(userId: userId),
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
