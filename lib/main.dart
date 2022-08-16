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

void main() async {
  init();
  WidgetsFlutterBinding.ensureInitialized();
  // Init Firebase
  await Firebase.initializeApp();
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
      ],
      child: BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
        selector: (state) => state,
        builder: (_, state) => Sizer(
          builder: (_, __, ___) => MaterialApp(
            title: "HotTake",
            debugShowCheckedModeBanner: false,
            theme: appTheme(context: context, theme: state),
            home: const MainPage(),
          ),
        ),
      ),
    );
  }
}
