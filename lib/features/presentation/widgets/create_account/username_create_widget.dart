import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class UsernameCreatewidget extends StatefulWidget {
  const UsernameCreatewidget({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeEntity theme;

  @override
  State<UsernameCreatewidget> createState() => _UsernameCreatewidgetState();
}

class _UsernameCreatewidgetState extends State<UsernameCreatewidget> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text =
        dI<CreateAccountCubitEvent>().read(context).state.username ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              // Title
              Text(
                "Pick your username!",
                style: fontStyle(
                  size: 17,
                  theme: widget.theme,
                  weight: FontWeight.w500,
                ),
              ),
              // Subtitle
              Text(
                "10 Character Limit",
                style: fontStyle(
                  size: 13,
                  theme: widget.theme,
                ),
              ),
              const SizedBox(height: 16),
              // Textfield
              TextfieldCreateWidget(
                controller: controller,
                theme: widget.theme,
                maxLength: 10,
              ),
              const SizedBox(height: 16),
              // Btn Ok
              ElevatedButtonText(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    // Check username
                    dI<UserFirestore>().checkUsername(
                      username: controller.text,
                      valid: () {
                        // Update State
                        dI<CreateAccountCubitEvent>()
                            .read(context)
                            .updateUsername(controller.text);

                        dI<CreateAccountCubitEvent>()
                            .read(context)
                            .updatePage(true);
                      },
                      notValid: () {
                        // Show Dialog
                        showDialog(
                          context: context,
                          builder: (context) => textDialog(
                            text: "Username is used by otherAccount",
                            size: 13,
                            color: convertTheme(widget.theme.third),
                            align: TextAlign.center,
                          ),
                        );
                      },
                    );
                  }
                },
                themeEntity: widget.theme,
                text: "Ok",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
