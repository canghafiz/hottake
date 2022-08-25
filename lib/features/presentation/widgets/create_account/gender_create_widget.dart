import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class GenderCreateWidget extends StatelessWidget {
  const GenderCreateWidget({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 36),
            // Title
            Text(
              "What's your gender?",
              style: fontStyle(
                size: 17,
                theme: theme,
                weight: FontWeight.w500,
              ),
            ),
            // Subtitle
            Text(
              "Oh hey there!",
              style: fontStyle(
                size: 13,
                theme: theme,
              ),
            ),
            const SizedBox(height: 16),
            // Gender Input
            GenderInput(theme: theme),
            const SizedBox(height: 16),
            // Btn Ok
            ElevatedButtonText(
              onTap: () {
                // Update State
                dI<CreateAccountCubitEvent>().read(context).updatePage(true);
              },
              themeEntity: theme,
              text: "Ok",
            ),
          ],
        ),
      ),
    );
  }
}

class GenderInput extends StatelessWidget {
  const GenderInput({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeEntity theme;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CreateAccountCubit, CreateAccountState, double>(
      selector: (state) => state.genderValue,
      builder: (context, state) => Row(
        children: [
          // Male
          Text(
            "Male",
            style: fontStyle(
              size: 13,
              theme: theme,
              color: convertTheme(theme.third),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Slider(
              min: 0,
              max: 100,
              divisions: 4,
              value: state,
              activeColor: convertTheme(theme.third),
              inactiveColor: convertTheme(theme.third).withOpacity(0.5),
              onChanged: (value) {
                // Update State
                dI<CreateAccountCubitEvent>().read(context).updateGender(value);
              },
            ),
          ),
          const SizedBox(width: 4),
          // Female
          Text(
            "Female",
            style: fontStyle(
              size: 13,
              theme: theme,
              color: convertTheme(theme.third),
            ),
          ),
        ],
      ),
    );
  }
}
