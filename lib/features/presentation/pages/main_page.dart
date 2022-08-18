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
          return const SignInPage();
        }
        return (snapshot.data == null)
            ? const SignInPage()
            : ControlPage(
                userId: snapshot.data!.uid,
                user: snapshot.data!,
              );
      },
    );
  }
}
