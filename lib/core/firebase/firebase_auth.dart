import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthImpl implements AuthService {
  static final _instance = FirebaseAuth.instance;
  final User? currentUser = _instance.currentUser;

  // Function
  Stream<User?> userStateChange() {
    return _instance.authStateChanges();
  }

  @override
  Future<AuthResponse> createAccount({
    required String email,
    required String password,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  }) async {
    try {
      // Call State
      updateStateOnLoad.call();

      // Call Firebase
      UserCredential user = await _instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Call State
      updateStateOnDone.call();

      // Return Value
      return AuthResponse(
        successMessage: "Your account has been created",
        userCredential: user,
      );
    } on FirebaseAuthException catch (e) {
      // Call State
      updateStateOnDone.call();
      if (e.code == 'weak-password') {
        return AuthResponse(
          errorMessage: "Weak password,user minimal 6 character",
        );
      }
      if (e.code == 'email-already-in-use') {
        return AuthResponse(
          errorMessage: "Email already in use",
        );
      }
      return AuthResponse(
        errorMessage: "Invalid email",
      );
    }
  }

  @override
  Future<AuthResponse?> loginWithEmail({
    required String email,
    required String password,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  }) async {
    try {
      // Call State
      updateStateOnLoad.call();

      // Call Firebase
      await _instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Call State
      updateStateOnDone.call();

      // Return Value
      return null;
    } on FirebaseAuthException catch (e) {
      // Call State
      updateStateOnDone.call();

      if (e.code == 'user-not-found') {
        return AuthResponse(errorMessage: "User not found");
      }
      if (e.code == 'wrong-password') {
        return AuthResponse(errorMessage: "Wrong password");
      }
      return AuthResponse(errorMessage: "Invalid email");
    }
  }

  @override
  Future<AuthResponse> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return AuthResponse(
        userCredential: userCredential,
      );
    } catch (e) {
      debugPrint("Login with google error on $e");

      return AuthResponse(errorMessage: "Login with google error on $e");
    }
  }

  @override
  Future<AuthResponse> changePassword({
    required String email,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  }) async {
    try {
      // Call State
      updateStateOnLoad.call();

      // Call Firebase
      await _instance.sendPasswordResetEmail(email: email);

      // Call State
      updateStateOnDone.call();

      return AuthResponse(
          successMessage:
              "Password reset link has been delivered to your email $email");
    } catch (e) {
      // Call State
      updateStateOnDone.call();

      // Return Value
      return AuthResponse(errorMessage: "Change password request error on $e");
    }
  }

  @override
  Future<void> logout() async {
    await _instance.signOut();
  }
}
