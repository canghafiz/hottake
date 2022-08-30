import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({
    Key? key,
    required this.user,
    required this.postId,
  }) : super(key: key);
  final User user;
  final String? postId;

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  void initState() {
    super.initState();
    // State
    initialState(context: context, user: widget.user);

    // Notification
    dI<NotificationService>().subAllTopics(widget.user.uid);
    dI<NotificationService>().setupMessageHandling(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(userId: widget.user.uid, user: widget.user),
      MapPage(
        userId: widget.user.uid,
        postId: widget.postId,
        user: widget.user,
        fromMainPage: true,
      ),
      PostLocationPage(
          postId: null, userId: widget.user.uid, user: widget.user),
      FavouritesPage(userId: widget.user.uid, user: widget.user),
      BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
        selector: (state) => state,
        builder: (context, theme) => StreamBuilder<DocumentSnapshot>(
          stream: dI<UserFirestore>().getRealTimeUser(widget.user.uid),
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
              userAuth: widget.user,
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
