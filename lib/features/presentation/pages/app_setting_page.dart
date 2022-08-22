import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class AppSettingPage extends StatelessWidget {
  const AppSettingPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final themeState = dI<ThemeCubitEvent>().read(context).state;
    return WillPopScope(
      onWillPop: () async {
        // Update State
        dI<ThemeCubitEvent>().read(context).update(themeState);
        return true;
      },
      child: BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
        selector: (state) => state,
        builder: (_, theme) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                // Update State
                dI<ThemeCubitEvent>().read(context).update(themeState);

                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: convertTheme(theme.secondary),
              ),
            ),
            title: Text(
              "App Setting",
              style: fontStyle(size: 15, theme: theme),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // App Theme
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          "App Theme",
                          style: fontStyle(
                            size: 11,
                            theme: theme,
                            weight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Data
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: themes
                                .map(
                                  (data) => GestureDetector(
                                    onTap: () {
                                      // Update State
                                      dI<ThemeCubitEvent>()
                                          .read(context)
                                          .update(data);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: convertTheme(data.primary),
                                        border: Border.all(
                                          color: (theme == data)
                                              ? convertTheme(data.secondary)
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Btn Save
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: ElevatedButtonText(
                      onTap: () {
                        // Update Data
                        dI<UserUpdateTheme>()
                            .call(userId: userId, theme: theme);

                        Navigator.pop(context);
                      },
                      themeEntity: theme,
                      text: "Save",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
