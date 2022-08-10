import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/features/domain/domain.dart';

class PollCubit {
  final TextEditingController controller;
  final PollEntity poll;

  PollCubit({required this.controller, required this.poll});
}

class PostState {
  String? longitude, latitude;
  NoteEntity? note;
  UserPollEntity? userPoll;
  RatingEntity? rating;

  PostState({
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.rating,
    required this.userPoll,
  });
}

class PostCubitEvent {
  PostCubit read(BuildContext context) {
    return context.read<PostCubit>();
  }
}

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(_default);

  static final _default = PostState(
    latitude: null,
    longitude: null,
    note: null,
    rating: null,
    userPoll: null,
  );

  // Function
  void clear() {
    emit(_default);
  }

  void updateLocation({
    required String latitude,
    required String longitude,
  }) {
    emit(
      PostState(
        latitude: latitude, // Update
        longitude: longitude, // Update
        note: state.note,
        rating: state.rating,
        userPoll: state.userPoll,
      ),
    );
  }

  void updateNote({
    required String title,
    required String note,
  }) {
    emit(
      PostState(
        latitude: state.latitude,
        longitude: state.longitude,
        note: NoteEntity(
          note: note,
          title: title,
        ), // Update
        rating: _default.rating,
        userPoll: _default.userPoll,
      ),
    );
  }

  void updateRating({
    required String description,
    required double value,
  }) {
    emit(
      PostState(
        latitude: state.latitude,
        longitude: state.longitude,
        note: _default.note,
        rating: RatingEntity(
          description: description,
          rating: value,
        ), // Update
        userPoll: _default.userPoll,
      ),
    );
  }

  void updateUserPoll({
    required PollCubit? value,
    required int? index,
    required bool updateItem,
  }) {
    state.userPoll = UserPollEntity([]);
    if (value != null) {
      if (index != null && updateItem) {
        state.userPoll!.polls[index] = value;
      } else if (index == null && !updateItem) {
        state.userPoll!.polls.add(value);
      } else {
        state.userPoll!.polls.removeAt(index!);
      }
    } else {
      if (state.userPoll!.polls.isEmpty) {
        state.userPoll!.polls.add(
          PollCubit(
            controller: TextEditingController(),
            poll: PollEntity(
              question: "",
              value: 0,
            ),
          ),
        );
      }
    }
    emit(
      PostState(
        latitude: state.latitude,
        longitude: state.longitude,
        note: _default.note,
        rating: _default.rating,
        userPoll: state.userPoll, // Update
      ),
    );
  }
}
