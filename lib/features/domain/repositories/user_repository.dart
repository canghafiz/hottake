import 'dart:async';

import 'package:hottake/features/domain/domain.dart';

abstract class UserRepository {
  FutureOr<void> createAccount({
    required String userId,
    required String email,
    required String username,
    required String? photo,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  });

  FutureOr<void> updateData({
    required String userId,
    required String username,
    required String? bio,
    required String? socialMedia,
    required ThemeEntity theme,
  });

  FutureOr<void> updatePhoto({
    required String userId,
    required String? url,
  });
}
