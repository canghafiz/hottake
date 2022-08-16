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
    onFocus: false,
  );

  // Function
  void clear() {
    emit(_default);
  }

  void updateCommentId(String? value) {
    emit(
      CommentState(
        commentId: value, // Update

        onFocus: state.onFocus,
      ),
    );
  }

  void updateShowEmoji(bool value) {
    emit(
      CommentState(
        commentId: state.commentId,
        onFocus: state.onFocus,
      ),
    );
  }
}
