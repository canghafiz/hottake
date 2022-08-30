import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hottake/features/presentation/presentation.dart';

PageRoute route(Widget screen) {
  return MaterialPageRoute(builder: (_) => screen);
}

void toSignInPage(BuildContext context) {
  Navigator.push(context, route(const SignInPage()));
}

void toPasswordPage(BuildContext context) {
  Navigator.push(context, route(const PasswordPage()));
}

void toSignUpPage(BuildContext context) {
  Navigator.push(context, route(const SignUpPage()));
}

void toPostCreatorPage({
  required BuildContext context,
  required String userId,
  required String? postId,
  required User user,
}) {
  Navigator.push(
    context,
    route(
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
    route(
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
  required User user,
}) {
  Navigator.push(
    context,
    route(
      MapPage(
        userId: userId,
        postId: postId,
        user: user,
      ),
    ),
  );
}

void toCommentsPage({
  required BuildContext context,
  required String userId,
  required String postId,
  required User user,
}) {
  Navigator.push(
    context,
    route(
      CommentsPage(
        postId: postId,
        userId: userId,
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
    route(
      ImageDetailPage(url: url),
    ),
  );
}

void toControlPage({
  required BuildContext context,
  required User user,
  required String? postId,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    route(ControlPage(user: user, postId: postId)),
    (route) => false,
  );
}

void toCreateAccountPage({
  required BuildContext context,
  required User user,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    route(CreateAccountPage(user: user)),
    (route) => false,
  );
}

void toMainPage({
  required BuildContext context,
  required String? postId,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    route(MainPage(postId: postId)),
    (route) => false,
  );
}

void toAppSettingPage({
  required BuildContext context,
  required String userId,
}) {
  Navigator.push(
    context,
    route(
      AppSettingPage(userId: userId),
    ),
  );
}

void toActivityPage({
  required BuildContext context,
  required String userId,
  required User user,
}) {
  Navigator.push(
    context,
    route(
      ActivityPage(userId: userId, user: user),
    ),
  );
}

void toNotificationPage({
  required BuildContext context,
  required User user,
}) {
  Navigator.push(
    context,
    route(NotificationPage(user: user)),
  );
}
