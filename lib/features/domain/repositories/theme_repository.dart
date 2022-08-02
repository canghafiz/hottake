import 'dart:async';

import 'package:hottake/features/domain/domain.dart';

abstract class ThemeRepository {
  FutureOr<ThemeEntity?> getTheme(int id);
}
