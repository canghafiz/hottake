import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Global Key
final navigatorKey = GlobalKey<NavigatorState>();

// Notification
Future<void> firebaseMessagingBackground(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Important Notifications",
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  init();
  WidgetsFlutterBinding.ensureInitialized();
  // Init Firebase
  await Firebase.initializeApp();
  // Notification
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackground);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // Set Device Orientation Only Potrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => dI<ThemeCubit>(),
        ),
        BlocProvider<BackendCubit>(
          create: (_) => dI<BackendCubit>(),
        ),
        BlocProvider<NavbarCubit>(
          create: (_) => dI<NavbarCubit>(),
        ),
        BlocProvider<PostCubit>(
          create: (_) => dI<PostCubit>(),
        ),
        BlocProvider<CommentCubit>(
          create: (_) => dI<CommentCubit>(),
        ),
        BlocProvider<CreateAccountCubit>(
          create: (_) => dI<CreateAccountCubit>(),
        ),
        BlocProvider<ImageCubit>(
          create: (_) => dI<ImageCubit>(),
        ),
      ],
      child: BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
        selector: (state) => state,
        builder: (_, state) => Sizer(
          builder: (_, __, ___) => MaterialApp(
            navigatorKey: navigatorKey,
            title: "HotTake",
            debugShowCheckedModeBanner: false,
            theme: appTheme(context: context, theme: state),
            home: const MainPage(postId: null),
          ),
        ),
      ),
    );
  }
}
