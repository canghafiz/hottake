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
      bio: (controller.text.isEmpty) ? null : controller.text,
      socialMedia: null,
      gender: state.genderValue,
      theme: dI<ThemeCubitEvent>().read(context).state,
    );

    // Update State
    dI<BackendCubitEvent>().read(context).updateStatus(BackendStatus.undoing);

    // Navigate
    toControlPage(context: context, user: widget.user);
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
              "Last step\nWrite a short bio or show off your social media!!",
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
            TextfieldCreateWidget(controller: controller, theme: widget.theme),
            const SizedBox(height: 16),
            // Btn Ok
            BlocSelector<CreateAccountCubit, CreateAccountState,
                CreateAccountState>(
              selector: (state) {
                return state;
              },
              builder: (context, state) {
                return BlocSelector<BackendCubit, BackendStatus, BackendStatus>(
                  selector: (state) {
                    return state;
                  },
                  builder: (context, bakcendStatus) {
                    return ElevatedButtonText(
                      onTap: () {
                        // Update Data
                        updateData(state);
                      },
                      themeEntity: widget.theme,
                      text: (bakcendStatus == BackendStatus.doing)
                          ? "Loading..."
                          : "Ok",
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
