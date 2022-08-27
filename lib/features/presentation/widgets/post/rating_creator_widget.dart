import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class RatingCreatorWidget extends StatefulWidget {
  const RatingCreatorWidget({
    Key? key,
    required this.postId,
    required this.userId,
    required this.theme,
    required this.user,
  }) : super(key: key);
  final String? postId;
  final String userId;
  final ThemeEntity theme;
  final User user;

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
        BlocSelector<PostCubit, PostState, RatingEntity>(
          selector: (state) => state.rating!,
          builder: (_, state) => RatingBar.builder(
            initialRating: state.rating,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
            itemSize: 36,
            unratedColor: convertTheme(widget.theme.secondary),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              // Update State
              dI<PostCubitEvent>().read(context).updateRating(
                    description: description.text,
                    value: value,
                  );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Description
        Form(
          key: formKey,
          child: BlocSelector<PostCubit, PostState, RatingEntity>(
            selector: (state) => state.rating!,
            builder: (_, state) => TextfieldPostWidget(
              controller: description..text = state.description,
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
        ),
        const SizedBox(height: 24),
        // Btn Post
        Center(
          child: BlocSelector<PostCubit, PostState, PostState>(
            selector: (state) => state,
            builder: (_, state) => ButtonCreatorWidget(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if (state.rating!.rating == 0) {
                    // Show Dialog
                    showDialog(
                      context: context,
                      builder: (context) => textDialog(
                        text: "Rating must be filled!",
                        size: 13,
                        color: Colors.red,
                        align: TextAlign.center,
                      ),
                    );
                  } else {
                    if (widget.postId == null) {
                      // Create
                      dI<CreatePost>().call(
                        theme: widget.theme,
                        userId: widget.userId,
                        longitude: state.longitude ?? "",
                        latitude: state.latitude ?? "",
                        note: null,
                        userPoll: null,
                        rating: RatingEntity.toMap(
                          rating: state.rating!.rating,
                          description: description.text,
                        ),
                        context: context,
                        user: widget.user,
                      );
                    } else {
                      // Update
                      dI<UpdatePost>().call(
                        theme: widget.theme,
                        userId: widget.userId,
                        postId: widget.postId!,
                        longitude: state.longitude ?? "",
                        latitude: state.latitude ?? "",
                        note: null,
                        userPoll: null,
                        rating: RatingEntity.toMap(
                          rating: state.rating!.rating,
                          description: description.text,
                        ),
                        context: context,
                        user: widget.user,
                      );
                    }
                  }
                }
              },
              title: "Post",
              theme: widget.theme,
            ),
          ),
        ),
      ],
    );
  }
}
