import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navbar_state.dart';

class NavbarCubitEvent {
  NavbarCubit read(BuildContext context) {
    return context.read<NavbarCubit>();
  }
}

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(_default);

  static final _default = NavbarState(bottomNav: 0, topNav: 0);

  // Function
  void clear() {
    emit(_default);
  }

  void updateBottom(int value) {
    emit(
      NavbarState(
        bottomNav: value, // Update
        topNav: state.topNav,
      ),
    );
  }

  void updateTop(int value) {
    emit(
      NavbarState(
        bottomNav: state.bottomNav,
        topNav: value, // Update
      ),
    );
  }
}
