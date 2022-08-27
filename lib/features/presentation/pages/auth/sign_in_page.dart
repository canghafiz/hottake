import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();

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
    // Clear State
    clearState(context);
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (context, themeEntity) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: convertTheme(themeEntity.secondary),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: backgroundWidget(
          context: context,
          urlAsset: smileEmojiImage,
          mainContent: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    // Logo
                    Center(
                      child: Image.asset(
                        emoji1Image,
                        height: MediaQuery.of(context).size.height * 1 / 7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      "Sign In for HotTake",
                      style: fontStyle(
                        size: 19,
                        theme: themeEntity,
                        weight: FontWeight.bold,
                      ),
                    ),
                    // Subtitle
                    Text(
                      "Post notes around your city, and find others",
                      style: fontStyle(
                        size: 11,
                        theme: themeEntity,
                        weight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Email
                    TextFormFieldCustom(
                      controller: email,
                      inputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Must Be Filled";
                        }
                      },
                      hintText: "Email",
                      themeEntity: themeEntity,
                    ),
                    const SizedBox(height: 16),
                    // Password
                    TextFormFieldCustom(
                      controller: password,
                      inputType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Must Be Filled";
                        }
                      },
                      hintText: "Password",
                      themeEntity: themeEntity,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    // Forgot Password
                    GestureDetector(
                      onTap: () {
                        // Navigate
                        toPasswordPage(context);
                      },
                      child: Text(
                        "Forgot Password ? Change Here",
                        style: fontStyle(
                          size: 10,
                          theme: themeEntity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Btn Sign In
                    BlocSelector<BackendCubit, BackendStatus, BackendStatus>(
                      selector: (state) => state,
                      builder: (_, state) => ElevatedButtonText(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            dI<AuthImpl>().loginWithEmail(
                              email: email.text,
                              password: password.text,
                              context: context,
                            );
                          }
                        },
                        themeEntity: themeEntity,
                        text: (state == BackendStatus.doing)
                            ? "Loading..."
                            : "Sign In",
                      ),
                    ),
                    // Or Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: convertTheme(themeEntity.secondary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "OR",
                            style: fontStyle(size: 9, theme: themeEntity),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Divider(
                              color: convertTheme(themeEntity.secondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Btn Sign Up
                    ElevatedButtonText(
                      onTap: () {
                        // Navigate
                        toSignUpPage(context);
                      },
                      themeEntity: themeEntity,
                      text: "Sign Up",
                      btnColor: convertTheme(themeEntity.secondary),
                      textColor: convertTheme(themeEntity.third),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
