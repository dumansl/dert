import 'package:dert/model/user_model.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'main_screen.dart';
import 'users_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel? user;
  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: UsersScreen(user: widget.user),
    );
  }

  DefaultTabController _newMethod() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(ScreenPadding.padding8px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeRadius.radius5px),
                  color: DertColor.card.purple,
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: DertColor.card.purpleWithOpacity,
                    borderRadius: BorderRadius.circular(SizeRadius.radius5px),
                  ),
                  tabs: [
                    Tab(
                      icon: Text(
                        DertText.home,
                        style: DertTextStyle.roboto.t16w500white,
                      ),
                    ),
                    Tab(
                      icon: Text(
                        "@${widget.user!.username}",
                        style: DertTextStyle.roboto.t16w500white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MainScreen(user: widget.user!),
                    UsersScreen(user: widget.user),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
