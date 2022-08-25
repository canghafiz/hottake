import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PollingCreatorWidget extends StatefulWidget {
  const PollingCreatorWidget({
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
  State<PollingCreatorWidget> createState() => _PollingCreatorWidgetState();
}

class _PollingCreatorWidgetState extends State<PollingCreatorWidget> {
  final formKey = GlobalKey<FormState>();

  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PostCubit, PostState, PostState>(
      selector: (state) => state,
      builder: (_, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Polls
          Form(
            key: formKey,
            child: Column(
              children: [
                // Question
                TextFormFieldCustom(
                  controller: controller..text = state.userPoll!.question,
                  inputType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Must be filled!";
                    }
                  },
                  hintText: "Question",
                  themeEntity: widget.theme,
                ),
                const SizedBox(height: 16),
                // Options
                Column(
                  children: state.userPoll!.polls.map((poll) {
                    final int index = state.userPoll!.polls
                        .indexWhere((data) => data == poll);
                    return Column(
                      children: [
                        PollingInputCreatorWidget(
                          hintText: "Option ${index + 1}",
                          index: index,
                          theme: widget.theme,
                          poll: poll,
                        ),
                        SizedBox(
                            height: (index == state.userPoll!.polls.length - 1)
                                ? 0
                                : 8),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Btn Post
          Center(
            child: ButtonCreatorWidget(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  List<Map<String, dynamic>> map = [];
                  for (int i = 0; i < state.userPoll!.polls.length; i++) {
                    final PollCubit pollCubit = state.userPoll!.polls[i];

                    map.add(
                      PollEntity.toMap(
                        option: pollCubit.controller.text,
                        value: pollCubit.poll.value,
                      ),
                    );
                  }

                  // Data
                  if (widget.postId == null) {
                    // Create
                    dI<CreatePost>().call(
                      userId: widget.userId,
                      longitude: state.longitude ?? "",
                      latitude: state.latitude ?? "",
                      note: null,
                      userPoll: UserPollEntity.toMap(
                        polls: map,
                        question: controller.text,
                      ),
                      rating: null,
                      context: context,
                      user: widget.user,
                    );
                  } else {
                    // Update
                    dI<UpdatePost>().call(
                      userId: widget.userId,
                      postId: widget.postId!,
                      longitude: state.longitude ?? "",
                      latitude: state.latitude ?? "",
                      note: null,
                      userPoll: UserPollEntity.toMap(
                        polls: map,
                        question: controller.text,
                      ),
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
  }
}

class PollingInputCreatorWidget extends StatefulWidget {
  const PollingInputCreatorWidget({
    Key? key,
    required this.hintText,
    required this.index,
    required this.theme,
    required this.poll,
  }) : super(key: key);
  final ThemeEntity theme;
  final String hintText;
  final int index;
  final PollCubit poll;

  @override
  State<PollingInputCreatorWidget> createState() =>
      _PollingInputCreatorWidgetState();
}

class _PollingInputCreatorWidgetState extends State<PollingInputCreatorWidget>
    with WidgetsBindingObserver {
  int value = 0;

  void udpateValue(int value) {
    setState(() {
      value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      widget.poll.controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Textfield
        Expanded(
          child: TextFormFieldCustom(
            controller: widget.poll.controller..text = widget.poll.poll.option,
            inputType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return "Must be filled!";
              }
            },
            hintText: widget.hintText,
            themeEntity: widget.theme,
          ),
        ),
        const SizedBox(width: 8),
        // Btn Add
        GestureDetector(
          onTap: () {
            // Update State
            dI<PostCubitEvent>().read(context).updatePolling(
                  index: null,
                  pollCubit: null,
                  initial: false,
                  question: null,
                );
          },
          child: Icon(
            Icons.add,
            color: convertTheme(widget.theme.third),
          ),
        ),
        const SizedBox(width: 8),
        // Btn Min
        (widget.index > 0)
            ? GestureDetector(
                onTap: () {
                  // Update State
                  dI<PostCubitEvent>().read(context).updatePolling(
                        index: widget.index,
                        pollCubit: null,
                        initial: false,
                        question: null,
                      );
                },
                child: Text(
                  "-",
                  style: fontStyle(
                    size: 20,
                    theme: widget.theme,
                    color: convertTheme(widget.theme.third),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
