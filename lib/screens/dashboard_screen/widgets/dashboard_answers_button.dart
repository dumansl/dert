import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardAnswersButton extends StatelessWidget {
  final int dermansLength;
  const DashboardAnswersButton({
    super.key,
    required this.dermansLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            "$dermansLength",
            style: DertTextStyle.roboto.t12w500white,
          ),
          SizedBox(width: ScreenPadding.padding8px),
          InkWell(onTap: () {}, child: _answerLogo()),
        ],
      ),
    );
  }

  Container _answerLogo() {
    return Container(
      height: IconSize.size20px,
      width: IconSize.size20px,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.answerLogo),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
