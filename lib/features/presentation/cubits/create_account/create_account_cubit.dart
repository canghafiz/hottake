import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_account_state.dart';

class CreateAccountCubitEvent {
  CreateAccountCubit read(BuildContext context) {
    return context.read<CreateAccountCubit>();
  }
}

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(_default);

  static final _default = CreateAccountState(
    bio: null,
    currentPage: 0,
    genderValue: 50,
    photoUrl: null,
    username: null,
  );

  // Function
  void clear() {
    emit(_default);
  }

  void updatePage(bool increament) {
    emit(
      CreateAccountState(
        bio: state.bio,
        currentPage: increament
            ? state.currentPage + 1
            : state.currentPage - 1, // Update
        genderValue: state.genderValue,
        photoUrl: state.photoUrl,
        username: state.username,
      ),
    );
  }

  void updateUsername(String value) {
    emit(
      CreateAccountState(
        bio: state.bio,
        currentPage: state.currentPage,
        genderValue: state.genderValue,
        photoUrl: state.photoUrl,
        username: value, // Update
      ),
    );
  }

  void updatePhotoUrl(String? value) {
    emit(
      CreateAccountState(
        bio: state.bio,
        currentPage: state.currentPage,
        genderValue: state.genderValue,
        photoUrl: value, // Update
        username: state.username,
      ),
    );
  }

  void updateBio(String value) {
    emit(
      CreateAccountState(
        bio: (value.isEmpty) ? null : value, // Update
        currentPage: state.currentPage,
        genderValue: state.genderValue,
        photoUrl: state.photoUrl,
        username: state.username,
      ),
    );
  }

  void updateGender(double value) {
    emit(
      CreateAccountState(
        bio: state.bio,
        currentPage: state.currentPage,
        genderValue: value,
        photoUrl: state.photoUrl,
        username: state.username,
      ),
    );
  }
}
