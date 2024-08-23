import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenPadding.padding16px),
      child: _mainEmpty(context),
    );
  }
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
