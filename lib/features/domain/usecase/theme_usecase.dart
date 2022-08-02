import 'dart:async';

import 'package:hottake/features/domain/domain.dart';

class GetTheme {
  final ThemeRepository repository;

  GetTheme(this.repository);

  FutureOr<ThemeEntity?> call(int id) {
    return repository.getTheme(id);
  }
}
