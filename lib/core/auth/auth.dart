import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class AuthResponse {
  String? errorMessage, userId, successMessage;
  UserCredential? userCredential;

  AuthResponse({
    this.errorMessage,
    this.userId,
    this.successMessage,
    this.userCredential,
  });
}

abstract class AuthService {
  Future<AuthResponse> createAccount({
    required String email,
    required String password,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  });

  Future<AuthResponse?> loginWithEmail({
    required String email,
    required String password,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  });

  Future<AuthResponse> loginWithGoogle();

  FutureOr<void> logout();

  Future<AuthResponse> changePassword({
    required String email,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  });
}

class AuthImpl {
  final AuthService _impl = dI<FirebaseAuthImpl>();

  Future<void> createAccount({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    // Chcek Username
    await dI<UserFirestore>().checkUsername(
      username: username,
      valid: () async {
        await _impl
            .createAccount(
          email: email,
          password: password,
          updateStateOnLoad: () {
            dI<BackendCubitEvent>()
                .read(context)
                .updateStatus(BackendStatus.doing);
          },
          updateStateOnDone: () {
            dI<BackendCubitEvent>()
                .read(context)
                .updateStatus(BackendStatus.undoing);
          },
        )
            .then(
          (response) {
            // When Success
            if (response.userId != null) {
              // Update Data
              dI<UserFirestore>().checkIsUserAvailable(
                userId: response.userId!,
                not: () {
                  // Call Data
                  dI<UserCreateAccount>().call(
                    userId: response.userId!,
                    email: email,
                    username: username,
                    photo: null,
                    bio: null,
                    socialMedia: null,
                    theme: dI<ThemeCubitEvent>().read(context).state,
                  );
                },
              );

              // Check Message Status
              if (response.successMessage != null) {
                // Call Dialog
                showDialog(
                  context: context,
                  builder: (_) => textDialog(
                    text: response.successMessage!,
                    size: 15,
                    color: Colors.green,
                    align: TextAlign.center,
                  ),
                );

                return;
              }
            }
            // Call Dialog
            showDialog(
              context: context,
              builder: (_) => textDialog(
                text: response.errorMessage!,
                size: 15,
                color: Colors.red,
                align: TextAlign.center,
              ),
            );
          },
        );
      },
      notValid: () {
        // Call Dialog
        showDialog(
          context: context,
          builder: (_) => textDialog(
            text: "Username has been used by other account",
            size: 15,
            color: Colors.red,
            align: TextAlign.center,
          ),
        );
      },
    );
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    await _impl
        .loginWithEmail(
      email: email,
      password: password,
      updateStateOnLoad: () {
        dI<BackendCubitEvent>().read(context).updateStatus(BackendStatus.doing);
      },
      updateStateOnDone: () {
        dI<BackendCubitEvent>()
            .read(context)
            .updateStatus(BackendStatus.undoing);
      },
    )
        .then(
      (response) {
        // When Error
        if (response != null) {
          // Call Dialog
          showDialog(
            context: context,
            builder: (_) => textDialog(
              text: response.errorMessage!,
              size: 15,
              color: Colors.red,
              align: TextAlign.center,
            ),
          );
          return;
        }
      },
    );
  }

  Future<void> loginWithGoogle(
    BuildContext context,
  ) async {
    await _impl.loginWithGoogle().then(
      (response) {
        // Error
        if (response.errorMessage != null) {
          // Call Dialog
          showDialog(
            context: context,
            builder: (_) => textDialog(
              text: response.errorMessage!,
              size: 15,
              color: Colors.red,
              align: TextAlign.center,
            ),
          );
          return;
        }
      },
    );
  }

  Future<void> changePassword({
    required String email,
    required BuildContext context,
  }) async {
    await _impl
        .changePassword(
      email: email,
      updateStateOnLoad: () {
        dI<BackendCubitEvent>().read(context).updateStatus(BackendStatus.doing);
      },
      updateStateOnDone: () {
        dI<BackendCubitEvent>()
            .read(context)
            .updateStatus(BackendStatus.undoing);
      },
    )
        .then((response) {
      if (response.successMessage != null) {
        // Call Dialog
        showDialog(
          context: context,
          builder: (_) => textDialog(
            text: response.successMessage!,
            size: 15,
            color: Colors.green,
            align: TextAlign.center,
          ),
        );
        return;
      }
      // Call Dialog
      showDialog(
        context: context,
        builder: (_) => textDialog(
          text: response.errorMessage!,
          size: 15,
          color: Colors.red,
          align: TextAlign.center,
        ),
      );
    });
  }

  Future<void> logout(BuildContext context) async {
    // Show Dialog
    showDialog(
      context: context,
      builder: (_) => alertDialogTextWith2Button(
        text: "Are you sure want sign out?",
        fontSize: 15,
        fontColor: Colors.black,
        onfalse: () {
          Navigator.pop(context);
        },
        onTrue: () {
          _impl.logout();
          // Update State
          clearState(context);
          dI<ThemeCubitEvent>().read(context).clear();
          Navigator.pop(context);
        },
        onFalseText: "Cancel",
        onTrueText: "Yes",
      ),
    );
  }
}
