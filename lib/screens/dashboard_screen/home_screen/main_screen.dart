import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _mainEmpty(context);
  }

  Widget _mainEmpty(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: ScreenUtil.getHeight(context) * 0.4,
          width: ScreenUtil.getHeight(context) * 0.4,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePath.onboardImage),
            ),
          ),
        ),
        SizedBox(height: ScreenPadding.padding16px),
        Text(
          DertText.mainEmptyText,
          textAlign: TextAlign.center,
          style: DertTextStyle.roboto.t16w700darkpurple,
        ),
      ],
    );
  }
}
