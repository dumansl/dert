import 'package:dert/model/follow_model.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'dashboard_circle_avatar.dart';

class FollowCard extends StatelessWidget {
  final FollowModel follow;
  final String gender;
  final String buttonImage;
  final VoidCallback onPressed;
  const FollowCard(
      {super.key,
      required this.follow,
      required this.buttonImage,
      required this.gender,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DashboardCircleAvatar(
          profileImageUrl: follow.profileImageUrl,
          gender: gender,
          radius: 25,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(follow.username,
                style: DertTextStyle.roboto.t16w700darkpurple),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: "Müslüm Gürses - ",
                      style: DertTextStyle.roboto.t10w800grey),
                  TextSpan(
                      text: "Yakarsa Dünyayı ...",
                      style: DertTextStyle.roboto.t10w400green),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressed,
          icon: Image.asset(
            buttonImage,
            width: IconSize.size30px,
            height: IconSize.size30px,
          ),
        ),
      ],
    );
  }
}
