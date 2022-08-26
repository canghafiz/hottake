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
    note: NoteEntity(note: "", title: ""),
    rating: null,
    userPoll: null,
  );

  // Function
  void clear() {
    emit(_default);
  }

  void updateLocation({
    required String? latitude,
    required String? longitude,
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
        note: null,
        rating: RatingEntity(
          description: description,
          rating: value,
        ), // Update
        userPoll: _default.userPoll,
      ),
    );
  }

  void updatePolling({
    required int? index,
    required String? question,
    required PollCubit? pollCubit,
    Map<String, dynamic>? userVotes,
    required bool initial,
  }) {
    // Not Initial
    if (!initial) {
      // Add | Min
      if (pollCubit == null) {
        if (index == null) {
          state.userPoll!.polls.add(
            PollCubit(
              controller: TextEditingController(),
              poll: PollEntity(option: "", value: 0),
            ),
          );
        } else {
          // Min
          state.userPoll!.polls.removeAt(index);
        }
      } else if (index != null && question != null) {
        state.userPoll!.question = question;
        state.userPoll!.polls[index] = pollCubit;
      }

      emit(
        PostState(
          latitude: state.latitude,
          longitude: state.longitude,
          note: null,
          rating: _default.rating,
          userPoll: state.userPoll, // Update
        ),
      );
    } else {
      emit(
        PostState(
          latitude: state.latitude,
          longitude: state.longitude,
          note: null,
          rating: _default.rating,
          userPoll: UserPollEntity(
            polls: [
              PollCubit(
                controller: TextEditingController(),
                poll: PollEntity(option: "", value: 0),
              ),
            ],
            question: "",
            userVotes: userVotes ?? {},
          ), // Update
        ),
      );
    }
  }
}
