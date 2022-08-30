import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class BioCreateWidget extends StatefulWidget {
  const BioCreateWidget({
    Key? key,
    required this.user,
    required this.theme,
  }) : super(key: key);
  final User user;
  final ThemeEntity theme;

  @override
  State<BioCreateWidget> createState() => _BioCreateWidgetState();
}

class _BioCreateWidgetState extends State<BioCreateWidget> {
  final controller = TextEditingController();

  void updateData(CreateAccountState state) {
    // Update State
    dI<BackendCubitEvent>().read(context).updateStatus(BackendStatus.doing);

    dI<UserUpdateData>().call(
      userId: widget.user.uid,
      email: widget.user.email!,
      username: state.username!,
      bio: state.bio,
      socialMedia: null,
      gender: state.genderValue,
      theme: widget.theme,
    );

    // Update State
    dI<BackendCubitEvent>().read(context).updateStatus(BackendStatus.undoing);

    // Navigate
    toControlPage(context: context, user: widget.user, postId: null);
  }

  @override
  void initState() {
    super.initState();
    controller.text =
        dI<CreateAccountCubitEvent>().read(context).state.bio ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 36),
            // Title
            Text(
              "Write a short bio or show off your social media!!",
              style: fontStyle(
                size: 17,
                theme: widget.theme,
                weight: FontWeight.w500,
              ),
            ),
            // Subtitle
            Text(
              "Help people find you (Optional)",
              style: fontStyle(
                size: 13,
                theme: widget.theme,
              ),
            ),
            const SizedBox(height: 16),
            // Bio
            TextfieldCreateWidget(
              controller: controller,
              theme: widget.theme,
            ),
            const SizedBox(height: 16),
            // Btn Ok
            BlocSelector<CreateAccountCubit, CreateAccountState,
                CreateAccountState>(
              selector: (state) => state,
              builder: (context, createAccountState) =>
                  BlocSelector<BackendCubit, BackendStatus, BackendStatus>(
                selector: (state) => state,
                builder: (context, backendStatus) => ElevatedButtonText(
                  onTap: () {
                    if (backendStatus == BackendStatus.undoing) {
                      // Update State
                      dI<CreateAccountCubitEvent>()
                          .read(context)
                          .updateBio(controller.text);

                      dI<SharedPreferencesService>()
                          .getLocationPermission()
                          .then(
                        (allow) {
                          if (allow) {
                            updateData(createAccountState);
                            return;
                          }
                          // Update State
                          dI<CreateAccountCubitEvent>()
                              .read(context)
                              .updatePage(true);
                        },
                      );
                    } else {
                      // Show Dialog
                      showDialog(
                        context: context,
                        builder: (context) => textDialog(
                          text: "You must wait",
                          size: 13,
                          color: Colors.red,
                          align: TextAlign.center,
                        ),
                      );
                    }
                  },
                  themeEntity: widget.theme,
                  text: (backendStatus == BackendStatus.doing)
                      ? "Loading..."
                      : "Ok",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
