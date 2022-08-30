import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class LocationCreateWidget extends StatelessWidget {
  const LocationCreateWidget({
    Key? key,
    required this.user,
    required this.theme,
  }) : super(key: key);
  final User user;
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    void updateData(CreateAccountState state) {
      // Update State
      dI<BackendCubitEvent>().read(context).updateStatus(BackendStatus.doing);

      dI<UserUpdateData>().call(
        userId: user.uid,
        email: user.email!,
        username: state.username!,
        bio: state.bio,
        socialMedia: null,
        gender: state.genderValue,
        theme: theme,
      );

      // Update State
      dI<BackendCubitEvent>().read(context).updateStatus(BackendStatus.undoing);

      // Navigate
      toControlPage(context: context, user: user, postId: null);
    }

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
              "Last Step",
              style: fontStyle(
                size: 17,
                theme: theme,
                weight: FontWeight.w500,
              ),
            ),
            // Subtitle
            Text(
              "Enable Location Permission",
              style: fontStyle(
                size: 13,
                theme: theme,
              ),
            ),
            const SizedBox(height: 16),
            // Btn Enable
            BlocSelector<BackendCubit, BackendStatus, BackendStatus>(
              selector: (state) => state,
              builder: (_, backendState) => BlocSelector<CreateAccountCubit,
                  CreateAccountState, CreateAccountState>(
                selector: (state) => state,
                builder: (_, createAccountState) => ElevatedButtonText(
                  onTap: () {
                    locationPermission().then(
                      (allow) {
                        if (allow) {
                          updateData(createAccountState);
                          // Call Storage
                          dI<SharedPreferencesService>()
                              .setLocationPermission(allow);
                          return;
                        }
                        // Show Dialog
                        showDialog(
                          context: context,
                          builder: (context) => textDialog(
                            text: "Location must have permission access",
                            size: 13,
                            color: convertTheme(theme.third),
                            align: TextAlign.center,
                          ),
                        );
                      },
                    );
                  },
                  themeEntity: theme,
                  text: (backendState == BackendStatus.doing)
                      ? "Loading..."
                      : "Enable",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
