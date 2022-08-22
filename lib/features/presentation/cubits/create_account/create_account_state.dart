part of 'create_account_cubit.dart';

class CreateAccountState {
  int currentPage;
  final String? username, photoUrl, bio;
  double genderValue;

  CreateAccountState({
    required this.bio,
    required this.currentPage,
    required this.genderValue,
    required this.photoUrl,
    required this.username,
  });
}
