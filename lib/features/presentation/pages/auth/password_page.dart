import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final formKey = GlobalKey<FormState>();

  final email = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Clear State
    clearState(context);

    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: convertTheme(theme.secondary),
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Title
                  Text(
                    "Change Password by Email",
                    style: fontStyle(size: 13, theme: theme),
                  ),
                  const SizedBox(height: 36),
                  Form(
                    key: formKey,
                    child:
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
                      themeEntity: theme,
                    ),
                  ),
                  const SizedBox(height: 36),
                  // Btn Send
                  BlocSelector<BackendCubit, BackendStatus, BackendStatus>(
                    selector: (state) => state,
                    builder: (_, state) => ElevatedButtonText(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          dI<AuthImpl>().changePassword(
                            email: email.text,
                            context: context,
                          );
                        }
                      },
                      themeEntity: theme,
                      text: (state == BackendStatus.doing)
                          ? "Loading..."
                          : "Send",
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
