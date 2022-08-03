import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BackendStatus { doing, undoing }

class BackendCubitEvent {
  BackendCubit read(BuildContext context) {
    return context.read<BackendCubit>();
  }
}

class BackendCubit extends Cubit<BackendStatus> {
  BackendCubit() : super(_default);

  static const _default = BackendStatus.undoing;

  // Function
  void clear() {
    emit(_default);
  }

  void updateStatus(BackendStatus value) {
    emit(value);
  }
}
