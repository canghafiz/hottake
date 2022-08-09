import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class TopNavbarWidget extends StatelessWidget {
  const TopNavbarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NavbarCubit, NavbarState, int>(
      selector: (state) => state.topNav,
      builder: (_, state) => BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
        selector: (state) => state,
        builder: (_, theme) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: convertTheme(theme.primary),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Notes Nearby
              GestureDetector(
                onTap: () {
                  // Update State
                  dI<NavbarCubitEvent>().read(context).updateTop(0);
                },
                child: Text(
                  "Notes Nearby",
                  style: fontStyle(
                    size: 13,
                    theme: theme,
                    weight: FontWeight.w500,
                    color: (state == 0)
                        ? null
                        : convertTheme(theme.secondary).withOpacity(0.5),
                  ),
                ),
              ),
              // Map
              GestureDetector(
                onTap: () {
                  // Update State
                  dI<NavbarCubitEvent>().read(context).updateTop(1);
                },
                child: Text(
                  "Map",
                  style: fontStyle(
                    size: 13,
                    theme: theme,
                    weight: FontWeight.w500,
                    color: (state == 1)
                        ? null
                        : convertTheme(theme.secondary).withOpacity(0.5),
                  ),
                ),
              ),
              // Favourites
              GestureDetector(
                onTap: () {
                  // Update State
                  dI<NavbarCubitEvent>().read(context).updateTop(2);
                },
                child: Text(
                  "Favourites",
                  style: fontStyle(
                    size: 13,
                    theme: theme,
                    weight: FontWeight.w500,
                    color: (state == 2)
                        ? null
                        : convertTheme(theme.secondary).withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlocSelector<NavbarCubit, NavbarState, int>(
        selector: (state) => state.bottomNav,
        builder: (_, state) =>
            BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
          selector: (state) => state,
          builder: (_, theme) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: convertTheme(theme.third),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Home
                  BottomNavbarIconButton(
                    activeValue: state,
                    value: 0,
                    theme: theme,
                    icon: Icons.home_outlined,
                    title: "Home",
                  ),
                  // Map
                  BottomNavbarIconButton(
                    activeValue: state,
                    value: 1,
                    theme: theme,
                    icon: Icons.location_on_outlined,
                    title: "Map",
                  ),
                  // Create Note
                  GestureDetector(
                    onTap: () {
                      // Update State
                      dI<NavbarCubitEvent>().read(context).updateBottom(2);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: convertTheme(theme.secondary),
                          child: Icon(
                            Icons.add,
                            color: convertTheme(theme.primary),
                          ),
                        ),
                        Text(
                          "Create Note",
                          style: fontStyle(
                            size: 9,
                            theme: theme,
                            color: (state == 2)
                                ? convertTheme(theme.primary)
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Favourites
                  BottomNavbarIconButton(
                    activeValue: state,
                    value: 3,
                    theme: theme,
                    icon: Icons.bookmark_border_outlined,
                    title: "Favourites",
                  ),
                  // Me
                  BottomNavbarIconButton(
                    activeValue: state,
                    value: 4,
                    theme: theme,
                    icon: Icons.person_outline,
                    title: "Me",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavbarIconButton extends StatelessWidget {
  const BottomNavbarIconButton({
    Key? key,
    required this.activeValue,
    required this.value,
    required this.theme,
    required this.icon,
    required this.title,
  }) : super(key: key);
  final int value, activeValue;
  final ThemeEntity theme;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          // Update State
          dI<NavbarCubitEvent>().read(context).updateBottom(value);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Icon(
              icon,
              color: (activeValue == value)
                  ? convertTheme(theme.primary)
                  : convertTheme(theme.secondary),
            ),
            Text(
              title,
              style: fontStyle(
                size: 9,
                theme: theme,
                color:
                    (activeValue == value) ? convertTheme(theme.primary) : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
