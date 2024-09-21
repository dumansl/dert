import 'package:dert/model/user_model.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'dashboard_circle_avatar.dart';

class DrendCard extends StatelessWidget {
  final UserModel user;
  const DrendCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DashboardCircleAvatar(
              profileImageUrl: user.profileImageUrl,
              gender: user.gender,
              radius: 25,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(user.username,
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
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenPadding.padding8px,
                vertical: ScreenPadding.padding4px,
              ),
              decoration: BoxDecoration(
                color: DertColor.button.darkpurple,
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeRadius.radius8px),
                ),
              ),
              child: Row(
                children: [
                  InkWell(onTap: () {}, child: _dertLogo()),
                  SizedBox(
                    width: ScreenPadding.padding8px,
                  ),
                  Text(
                    "${user.points}",
                    style: DertTextStyle.roboto.t12w500white,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenPadding.padding8px),
        const Divider(),
      ],
    );
  }

  Container _dertLogo() {
    return Container(
      height: IconSize.size20px,
      width: IconSize.size20px,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.dertLogov2),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
