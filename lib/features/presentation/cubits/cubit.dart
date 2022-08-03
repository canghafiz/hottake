import 'package:flutter/cupertino.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/presentation/presentation.dart';

void clearState(BuildContext context) {
  // Backend
  dI<BackendCubitEvent>().read(context).clear();
}
