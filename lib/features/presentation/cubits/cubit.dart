import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

void initialState({
  required BuildContext context,
  required User user,
}) {
  // Theme
  dI<UserFirestore>().updateTheme(
    userId: user.uid,
    updateTheme: (value) => dI<ThemeCubitEvent>().read(context).update(value),
  );
}

void clearState(BuildContext context) {
  // Backend
  dI<BackendCubitEvent>().read(context).clear();
  // Navbar
  dI<NavbarCubitEvent>().read(context).clear();
  // Post
  dI<PostCubitEvent>().read(context).clear();
  // Create Account
  dI<CreateAccountCubitEvent>().read(context).clear();
  // Image
  dI<CreateAccountCubitEvent>().read(context).clear();
}
