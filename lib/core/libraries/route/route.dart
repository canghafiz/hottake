import 'package:firebase_auth/firebase_auth.dart';
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
  required User user,
  required bool forOwn,
}) {
  Navigator.push(
    context,
    _route(
      UserPage(
        userId: userId,
        initialTab: initialTab,
        user: user,
        forOwn: forOwn,
        initPage: false,
      ),
    ),
  );
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
  required User user,
}) {
  Navigator.push(
    context,
    _route(
      PostCreatorPage(
        userId: userId,
        postId: postId,
        user: user,
      ),
    ),
  );
}

void toPostLocationPage({
  required BuildContext context,
  required String userId,
  required String? postId,
  required User user,
}) {
  Navigator.push(
    context,
    _route(
      PostLocationPage(
        userId: userId,
        postId: postId,
        user: user,
      ),
    ),
  );
}

void toMapPage({
  required BuildContext context,
  required String userId,
  required String? postId,
  required ThemeEntity theme,
  required User user,
}) {
  Navigator.push(
    context,
    _route(
      MapPage(
        userId: userId,
        postId: postId,
        theme: theme,
        user: user,
      ),
    ),
  );
}

void toCommentsPage({
  required BuildContext context,
  required String userId,
  required String postId,
  required PostEntity post,
  required User user,
}) {
  Navigator.push(
    context,
    _route(
      CommentsPage(
        postId: postId,
        userId: userId,
        post: post,
        user: user,
      ),
    ),
  );
}

void toImageDetailPage({
  required BuildContext context,
  required String url,
}) {
  Navigator.push(
    context,
    _route(
      ImageDetailPage(url: url),
    ),
  );
}

void toControlPage({
  required BuildContext context,
  required User user,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    _route(ControlPage(userId: user.uid, user: user)),
    (route) => false,
  );
}
