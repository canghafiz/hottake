import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';

class ThemeCubitEvent {
  static ThemeCubit read(BuildContext context) {
    return context.read<ThemeCubit>();
  }
}

class ThemeCubit extends Cubit<ThemeEntity> {
  ThemeCubit() : super(_default.call());

  static ThemeEntity _default() {
    return dI<GetTheme>().call(3) as ThemeEntity;
  }

  // Function
  void clear() {
    emit(_default.call());
  }

  void update(ThemeEntity value) {
    emit(value);
  }
}
