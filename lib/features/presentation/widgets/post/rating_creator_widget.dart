import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class RatingCreatorWidget extends StatefulWidget {
  const RatingCreatorWidget({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeEntity theme;

  @override
  State<RatingCreatorWidget> createState() => _RatingCreatorWidgetState();
}

class _RatingCreatorWidgetState extends State<RatingCreatorWidget> {
  final formKey = GlobalKey<FormState>();

  final description = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating
        const SizedBox(height: 16),
        // Description
        Form(
          key: formKey,
          child: TextfieldPostWidget(
            controller: description,
            hintText: "Description",
            theme: widget.theme,
            validator: (value) {
              if (value!.isEmpty) {
                return "Must be filled!";
              }
            },
            type: TextInputType.text,
            maxLine: 8,
          ),
        ),
        const SizedBox(height: 24),
        // Btn Next
        Center(
          child: ButtonCreatorWidget(
            onTap: () {
              if (formKey.currentState!.validate()) {
                // Update State
                dI<PostCubitEvent>().read(context).updateRating(
                      description: description.text,
                      value: 0,
                    );

                // Navigate
                toPostLocationPage(context);
              }
            },
            title: "Next",
            theme: widget.theme,
          ),
        ),
      ],
    );
  }
}
