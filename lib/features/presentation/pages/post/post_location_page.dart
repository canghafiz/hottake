import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PostLocationPage extends StatelessWidget {
  const PostLocationPage({
    Key? key,
    required this.postId,
    required this.userId,
  }) : super(key: key);
  final String? postId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemeCubit, ThemeEntity, ThemeEntity>(
      selector: (state) => state,
      builder: (_, theme) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: convertTheme(theme.secondary),
            ),
          ),
          title: Text(
            "Select Location",
            style: fontStyle(size: 15, theme: theme),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        body: Column(
          children: [
            // Map
            Expanded(
              child: BlocSelector<PostCubit, PostState, PostState>(
                selector: (state) => state,
                builder: (_, state) => Container(),
              ),
            ),
            const SizedBox(height: 16),
            // Btn Next
            ButtonCreatorWidget(
                onTap: () {
                  // Navigate
                  toPostCreatorPage(
                    context: context,
                    userId: userId,
                    postId: postId,
                  );
                },
                title: "Next",
                theme: theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
