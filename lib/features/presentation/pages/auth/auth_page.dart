import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (context, theme) => Scaffold(
        body: backgroundWidget(
          context: context,
          urlAsset: smileEmojiImage,
          gradientColor: Colors.blue,
          mainContent: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Title
                Center(
                  child: Text(
                    "HotTake",
                    style: fontStyle(size: 17, theme: theme),
                  ),
                ),
                const SizedBox(height: 16),
                // Btn
                Flexible(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Btn Login With Google
                          ElevatedButtonTextWithIcon(
                            onTap: () {
                              dI<AuthImpl>().loginWithGoogle(context);
                            },
                            themeEntity: theme,
                            text: "Continue With Google",
                            icon: Image.asset(
                              googleImage,
                              width: 24,
                              height: 24,
                            ),
                            btnColor: convertTheme(theme.secondary),
                            textColor: convertTheme(theme.primary),
                          ),
                          const SizedBox(height: 16),
                          // Btn Login With Email
                          ElevatedButtonTextWithIcon(
                            onTap: () {
                              // Navigate
                              toSignInPage(context);
                            },
                            themeEntity: theme,
                            text: "Continue With Email",
                            icon: Icon(
                              Icons.email,
                              color: convertTheme(theme.primary),
                            ),
                            btnColor: convertTheme(theme.secondary),
                            textColor: convertTheme(theme.primary),
                          ),
                          const SizedBox(height: 16),
                          // Btn Sign Up
                          TextButton(
                            onPressed: () {
                              // Navigate
                              toSignUpPage(context);
                            },
                            child: Text(
                              "Sign Up",
                              style: fontStyle(
                                size: 15,
                                theme: theme,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
