import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class AuthResponse {
  String? errorMessage, successMessage;
  UserCredential? userCredential;

  AuthResponse({
    this.errorMessage,
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
    required BuildContext context,
  }) async {
    await _impl
        .createAccount(
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
        //  Error
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

        // Navigate
        toCreateAccountPage(
          context: context,
          user: response.userCredential!.user!,
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

        // Navigate
        toMainPage(context: context);
      },
    );
  }

  Future<void> loginWithGoogle(
    BuildContext context,
  ) async {
    await _impl.loginWithGoogle().then(
      (response) async {
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

        // Navigate
        toMainPage(context: context);
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

  Future<void> logout({
    required BuildContext context,
    required ThemeEntity theme,
  }) async {
    // Show Dialog
    showDialog(
      context: context,
      builder: (_) => alertDialogTextWith2Button(
        text: "Are you sure want sign out?",
        fontSize: 15,
        fontColor: convertTheme(theme.secondary),
        onfalse: () {
          Navigator.pop(context);
        },
        onTrue: () {
          _impl.logout();
          // Update State
          clearState(context);
          dI<ThemeCubitEvent>().read(context).clear();

          // Navigate
          toMainPage(context: context);
        },
        onFalseText: "Cancel",
        onTrueText: "Yes",
      ),
    );
  }
}
