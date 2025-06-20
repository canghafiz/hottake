import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'comment_state.dart';

class CommentCubitEvent {
  CommentCubit read(BuildContext context) {
    return context.read<CommentCubit>();
  }
}

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(_default);

  static final _default = CommentState(
    commentId: null,
    focusNode: FocusNode(),
  );

  // Function
  void clear() {
    emit(_default);
  }

  void updateCommentId(String? value) {
    emit(
      CommentState(
        commentId: value, // Update
        focusNode: state.focusNode,
      ),
    );
  }

  void showFocus() {
    state.focusNode.requestFocus();
  }

  void unFocus() {
    state.focusNode.unfocus();
  }
}
