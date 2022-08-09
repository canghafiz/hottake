import 'package:flutter/cupertino.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

void initState({
  required BuildContext context,
  required String userId,
}) {
  // Theme
  dI<UserFirestore>().updateTheme(
    userId: userId,
    updateTheme: (value) => dI<ThemeCubitEvent>().read(context).update(value),
  );
}

void clearState(BuildContext context) {
  // Backend
  dI<BackendCubitEvent>().read(context).clear();
  // Navbar
  dI<NavbarCubitEvent>().read(context).clear();
}
