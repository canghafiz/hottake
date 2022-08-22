import 'dart:async';

import 'package:hottake/features/domain/domain.dart';

abstract class UserRepository {
  FutureOr<void> updateData({
    required String userId,
    required String email,
    required String username,
    required String? bio,
    required String? socialMedia,
    required double gender,
    required ThemeEntity theme,
  });

  FutureOr<void> updatePhoto({
    required String userId,
    required String? url,
  });

  FutureOr<void> updateTheme({
    required String userId,
    required ThemeEntity theme,
  });
}
