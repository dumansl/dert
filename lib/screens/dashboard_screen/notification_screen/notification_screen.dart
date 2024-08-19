import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final bool showScaffold;

  const NotificationScreen({super.key, this.showScaffold = false});

  @override
  Widget build(BuildContext context) {
    if (showScaffold) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(" Notification"),
        ),
        body: const Center(
          child: Text(" Notification Screen with Scaffold"),
        ),
      );
    } else {
      return const Center(
        child: Text(" Notification Screen without Scaffold"),
      );
    }
  }
}
