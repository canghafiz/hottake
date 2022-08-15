import 'package:flutter/material.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

PageRoute _route(Widget screen) {
  return MaterialPageRoute(builder: (_) => screen);
}

void toUserPage({
  required BuildContext context,
  required String userId,
  required int initialTab,
}) {
  Navigator.push(
      context, _route(UserPage(userId: userId, initialTab: initialTab)));
}

void toPasswordPage(BuildContext context) {
  Navigator.push(context, _route(const PasswordPage()));
}

void toSignUpPage(BuildContext context) {
  Navigator.push(context, _route(const SignUpPage()));
}

void toEditUserPage({
  required BuildContext context,
  required String userId,
  required UserEntity user,
}) {
  Navigator.push(
    context,
    _route(
      EditUserPage(user: user, userId: userId),
    ),
  );
}

void toPostCreatorPage({
  required BuildContext context,
  required String userId,
  required String? postId,
}) {
  Navigator.push(
    context,
    _route(
      PostCreatorPage(
        userId: userId,
        postId: postId,
      ),
    ),
  );
}

void toPostLocationPage({
  required BuildContext context,
  required String userId,
  required String? postId,
}) {
  Navigator.push(
    context,
    _route(
      PostLocationPage(
        userId: userId,
        postId: postId,
      ),
    ),
  );
}
