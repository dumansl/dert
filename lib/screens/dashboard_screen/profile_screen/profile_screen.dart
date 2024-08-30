import 'package:dert/model/user_model.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_appbar.dart';
import 'package:dert/screens/dashboard_screen/widgets/dert_circle_avatar.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/horizontal_page_route.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final bool showScaffold;
  final UserModel? user;
  const ProfileScreen(
      {super.key, this.showScaffold = false, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.showScaffold) {
      return Scaffold(
        appBar: DertAppbar(
          title: DertText.profile,
        ),
        body: _profile(context),
      );
    } else {
      return _profile(context);
    }
  }

  Widget _profile(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 50,
          child: _profileHeader(context),
        ),
        Expanded(
          flex: 50,
          child: Container(color: Colors.black),
        ),
      ],
    );
  }

  Widget _profileHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DertCircleAvatar(
          profileImageUrl: widget.user?.profileImageUrl,
          gender: widget.user!.gender,
          radius: 50,
        ),
        SizedBox(height: ScreenPadding.padding16px),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  createHorizontalPageRoute(
                      FollowScreen(showFollowers: true, user: widget.user!)),
                );
              },
              child: Text("\n${DertText.followers}",
                  style: DertTextStyle.roboto.t14w400purple),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  createHorizontalPageRoute(
                      FollowScreen(showFollowers: false, user: widget.user!)),
                );
              },
              child: Text("\n${DertText.follows}",
                  style: DertTextStyle.roboto.t14w400purple),
            ),
          ],
        ),
        SizedBox(height: ScreenPadding.padding16px),
        Text("@${widget.user!.username}",
            style: DertTextStyle.roboto.t24w400purple),
      ],
    );
  }
}
