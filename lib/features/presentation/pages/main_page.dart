import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: dI<FirebaseAuthImpl>().userStateChange(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const AuthPage();
        }
        return (snapshot.data == null)
            ? const AuthPage()
            : FutureBuilder<bool>(
                future: dI<UserFirestore>()
                    .checkIsUserAvailable(snapshot.data!.uid),
                builder: (_, available) {
                  if (!available.hasData) {
                    return const AuthPage();
                  }
                  return (!available.data!)
                      ? CreateAccountPage(user: snapshot.data!)
                      : ControlPage(user: snapshot.data!);
                },
              );
      },
    );
  }
}
