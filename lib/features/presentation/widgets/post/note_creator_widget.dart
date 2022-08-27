import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class NoteCreatorwidget extends StatefulWidget {
  const NoteCreatorwidget({
    Key? key,
    required this.postId,
    required this.theme,
    required this.userId,
    required this.user,
  }) : super(key: key);
  final String? postId;
  final String userId;
  final ThemeEntity theme;
  final User user;

  @override
  State<NoteCreatorwidget> createState() => _NoteCreatorwidgetState();
}

class _NoteCreatorwidgetState extends State<NoteCreatorwidget> {
  final formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final note = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PostCubit, PostState, NoteEntity?>(
      selector: (state) => state.note,
      builder: (_, noteState) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              // Title
              TextfieldPostWidget(
                controller: title..text = noteState?.title ?? "",
                hintText: "Title",
                theme: widget.theme,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Must be filled!";
                  }
                },
                type: TextInputType.text,
              ),
              const SizedBox(height: 16),
              // Note
              TextfieldPostWidget(
                controller: note..text = noteState?.note ?? "",
                hintText: "Note",
                theme: widget.theme,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Must be filled!";
                  }
                },
                type: TextInputType.text,
                maxLine: 8,
              ),
              const SizedBox(height: 24),
              // Btn Post
              BlocSelector<PostCubit, PostState, PostState>(
                selector: (state) => state,
                builder: (_, state) => ButtonCreatorWidget(
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      // Data
                      if (widget.postId == null) {
                        // Create
                        dI<CreatePost>().call(
                          theme: widget.theme,
                          userId: widget.userId,
                          longitude: state.longitude ?? "",
                          latitude: state.latitude ?? "",
                          note: NoteEntity.toMap(
                              title: title.text, note: note.text),
                          userPoll: null,
                          rating: null,
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
                          note: NoteEntity.toMap(
                              title: title.text, note: note.text),
                          userPoll: null,
                          rating: null,
                          context: context,
                          user: widget.user,
                        );
                      }
                    }
                  },
                  title: "Post",
                  theme: widget.theme,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
