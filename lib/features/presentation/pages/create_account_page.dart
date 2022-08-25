import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  void initState() {
    super.initState();
    // Update State
    dI<CreateAccountCubitEvent>().read(context).clear();
  }

  @override
  Widget build(BuildContext context) {
    contents(ThemeEntity theme) {
      return [
        UsernameCreatewidget(theme: theme),
        GenderCreateWidget(theme: theme),
        PhotoCreateWidget(theme: theme, userId: widget.user.uid),
        BioCreateWidget(theme: theme, user: widget.user),
        LocationCreateWidget(theme: theme, user: widget.user),
      ];
    }

    const assetsImages = [
      writeEmojiImage,
      writeEmojiImage,
      awesomeEmojiImage,
      writeEmojiImage,
      locationEmojiImage,
    ];

    void backFunction(int page) {
      if (page > 0) {
        // Update State
        dI<CreateAccountCubitEvent>().read(context).updatePage(false);
      }
    }

    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) =>
          BlocSelector<CreateAccountCubit, CreateAccountState, int>(
        selector: (state) => state.currentPage,
        builder: (_, currentPage) => WillPopScope(
          onWillPop: () async {
            backFunction(currentPage);
            return false;
          },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: (currentPage > 0)
                  ? IconButton(
                      onPressed: () {
                        backFunction(currentPage);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: convertTheme(theme.secondary),
                      ),
                    )
                  : null,
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            body: backgroundWidget(
              context: context,
              urlAsset: assetsImages.elementAt(currentPage),
              mainContent: contents(theme).elementAt(currentPage),
            ),
          ),
        ),
      ),
    );
  }
}
