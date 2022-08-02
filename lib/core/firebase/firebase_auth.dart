import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hottake/core/core.dart';

class FirebaseAuthImpl implements AuthService {
  static final _instance = FirebaseAuth.instance;
  final User? currentUser = _instance.currentUser;

  // Function
  Stream<User?> userStateChange() {
    return _instance.authStateChanges();
  }

  @override
  Future<AuthResponse> changePassword({
    required String email,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  }) async {
    return AuthResponse(errorMessage: "");
  }

  @override
  Future<AuthResponse> createAccount({
    required String email,
    required String password,
    required String name,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  }) async {
    return AuthResponse(errorMessage: "");
  }

  @override
  Future<AuthResponse?> loginWithEmail({
    required String email,
    required String password,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  }) async {
    return null;
  }

  @override
  Future<void> logout() async {
    await _instance.signOut();
  }
}
