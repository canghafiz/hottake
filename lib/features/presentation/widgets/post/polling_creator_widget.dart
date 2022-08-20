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
              children: state.userPoll!.polls.map((poll) {
                final int index =
                    state.userPoll!.polls.indexWhere((data) => data == poll);
                return Column(
                  children: [
                    PollingInputCreatorWidget(
                      hintText: "Question ${index + 1}",
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
                          question: pollCubit.controller.text,
                          value: pollCubit.poll.value),
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
                      userPoll: UserPollEntity.toMap(map),
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
                      userPoll: UserPollEntity.toMap(map),
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
            controller: widget.poll.controller
              ..text = widget.poll.poll.question,
            inputType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return "Must be filled!";
              }
            },
            suffix: GestureDetector(
              onTap: () {
                // Show Dialog
                showDialog(
                  context: context,
                  builder: (context) => alertDialogWithCustomContent(
                    PickValuePollingCreatorWidget(
                      theme: widget.theme,
                      initValue: widget.poll.poll.value,
                      index: widget.index,
                      pollCubit: widget.poll,
                    ),
                  ),
                );
              },
              child: Text(
                " ${widget.poll.poll.value}%",
                style: fontStyle(
                  size: 13,
                  theme: widget.theme,
                ),
              ),
            ),
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

class PickValuePollingCreatorWidget extends StatelessWidget {
  const PickValuePollingCreatorWidget({
    Key? key,
    required this.index,
    required this.theme,
    required this.initValue,
    required this.pollCubit,
  }) : super(key: key);
  final PollCubit pollCubit;
  final ThemeEntity theme;
  final int initValue, index;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PostCubit, PostState, PostState>(
      selector: (state) => state,
      builder: (_, state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider
          Slider(
            value: (state.userPoll!.polls[index] as PollCubit)
                .poll
                .value
                .toDouble(),
            onChanged: (value) {
              // Update State
              dI<PostCubitEvent>().read(context).updatePolling(
                    index: index,
                    pollCubit: PollCubit(
                      controller: pollCubit.controller,
                      poll: PollEntity(
                        question: pollCubit.poll.question,
                        value: value.toInt(),
                      ),
                    ),
                    initial: false,
                  );
            },
            activeColor: convertTheme(theme.third),
            inactiveColor: convertTheme(theme.third).withOpacity(0.5),
            min: 0,
            max: 100,
          ),
          // Value
          Center(
            child: Text(
              "${(state.userPoll!.polls[index] as PollCubit).poll.value}%",
              style: fontStyle(
                size: 13,
                theme: theme,
                color: convertTheme(theme.third),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
