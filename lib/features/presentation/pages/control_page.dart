import 'package:cloud_firestore/cloud_firestore.dart';
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
      BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
        selector: (state) => state,
        builder: (context, theme) => StreamBuilder<DocumentSnapshot>(
          stream: dI<UserFirestore>().getRealTimeUser(user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: convertTheme(theme.secondary),
                ),
              );
            }
            // Model
            final UserEntity userEntity = UserEntity.fromMap(
                snapshot.data!.data() as Map<String, dynamic>);

            return EditUserPage(
              user: userEntity,
              userId: snapshot.data!.id,
              userAuth: user,
            );
          },
        ),
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
                builder: (_, bottomNav) => pages.elementAt(bottomNav),
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
