import 'dart:async';

class AuthResponse {
  String? errorMessage, userId, successMessage;

  AuthResponse({this.errorMessage, this.userId, this.successMessage});
}

abstract class AuthService {
  Future<AuthResponse> createAccount({
    required String email,
    required String password,
    required String name,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  });

  Future<AuthResponse?> loginWithEmail({
    required String email,
    required String password,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  });

  FutureOr<void> logout();

  Future<AuthResponse> changePassword({
    required String email,
    required Function updateStateOnLoad,
    required Function updateStateOnDone,
  });
}
