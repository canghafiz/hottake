import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              try {
                final login = await FacebookAuth.instance.login(
                  loginBehavior: LoginBehavior.webOnly,
                  permissions: [
                    'email',
                    'public_profile',
                  ],
                );

                if (login.status == LoginStatus.success) {
                  final credential =
                      FacebookAuthProvider.credential(login.accessToken!.token);
                  await FirebaseAuth.instance.signInWithCredential(credential);
                  final userData = await FacebookAuth.instance.getUserData();

                  print(userData);
                }
              } catch (e) {}
            },
            child: const Text("Facebook"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              try {
                // Trigger the authentication flow
                final GoogleSignInAccount? googleUser =
                    await GoogleSignIn().signIn();

                if (googleUser != null) {
                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication? googleAuth =
                      await googleUser.authentication;

                  if (googleAuth != null) {
                    // Create a new credential
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );

                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                  } else {
                    print("Gagal");
                  }
                } else {
                  print("Gagal");
                }
              } catch (e) {}
            },
            child: const Text("Google"),
          ),
        ],
      ),
    );
  }
}
