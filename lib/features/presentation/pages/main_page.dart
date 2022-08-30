import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key,
  required this.postId,
  }) : super(key: key);
  final String? postId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: dI<FirebaseAuthImpl>().userStateChange(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return (!snapshot.hasData)
              ? const AuthPage()
              : FutureBuilder<bool>(
                  future: dI<UserFirestore>()
                      .checkIsUserAvailable(snapshot.data!.uid),
                  builder: (_, available) {
                    if (available.connectionState == ConnectionState.done) {
                      return (!available.data!)
                          ? CreateAccountPage(user: snapshot.data!)
                          : ControlPage(
                              user: snapshot.data!,
                              postId: postId,
                            );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  },
                );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }
}
