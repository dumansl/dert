import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class FollowCard extends StatelessWidget {
  final String username;
  final String buttonImage;
  const FollowCard(
      {super.key, required this.username, required this.buttonImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: DertColor.background.darkpurple,
          radius: 25,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(username, style: DertTextStyle.roboto.t16w700darkpurple),
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
        Image.asset(
          buttonImage,
          width: 30,
          height: 30,
        )
      ],
    );
  }
}
