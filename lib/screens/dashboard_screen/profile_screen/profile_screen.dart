import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool showScaffold;

  const ProfileScreen({super.key, this.showScaffold = false});

  @override
  Widget build(BuildContext context) {
    if (showScaffold) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: const Center(
          child: Text("Profile Screen with Scaffold"),
        ),
      );
    } else {
      return const Center(
        child: Text("Profile Screen without Scaffold"),
      );
    }
  }
}
