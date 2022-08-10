import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';
import 'package:hottake/features/domain/domain.dart';
import 'package:hottake/features/presentation/presentation.dart';

class PollingCreatorWidget extends StatefulWidget {
  const PollingCreatorWidget({
    Key? key,
    required this.theme,
  }) : super(key: key);
  final ThemeEntity theme;

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
                return PollingInputCreatorWidget(
                  hintText: "Question ${index + 1}",
                  index: index,
                  theme: widget.theme,
                  poll: poll,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // Btn Next
          ButtonCreatorWidget(
            onTap: () {
              if (formKey.currentState!.validate()) {
                // Update state
                for (int i = 0; i < state.userPoll!.polls.length; i++) {
                  dI<PostCubitEvent>().read(context).updateUserPoll(
                        value: state.userPoll!.polls[i],
                        index: i,
                        updateItem: true,
                      );
                }

                // Navigate
                toPostLocationPage(context);
              }
            },
            title: "Next",
            theme: widget.theme,
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
            controller: widget.poll.controller,
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
            dI<PostCubitEvent>().read(context).updateUserPoll(
                  value: PollCubit(
                    controller: TextEditingController(),
                    poll: PollEntity(
                      question: "",
                      value: 0,
                    ),
                  ),
                  index: null,
                  updateItem: false,
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
                  dI<PostCubitEvent>().read(context).updateUserPoll(
                        value: widget.poll,
                        index: widget.index,
                        updateItem: false,
                      );
                },
                child: Icon(
                  Icons.minimize,
                  color: convertTheme(widget.theme.third),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
