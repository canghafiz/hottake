import 'package:flutter/material.dart';
import 'package:hottake/core/core.dart';
import 'package:hottake/dependency_injection.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            dI<AuthImpl>().logout(context);
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
