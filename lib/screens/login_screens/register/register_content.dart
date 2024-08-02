import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class RegisterContent extends StatelessWidget {
  const RegisterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 40,
          child: Center(
            child: Container(
              width: ScreenUtil.getWidth(context) * 0.5,
              height: ScreenUtil.getHeight(context) * 0.1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePath.logo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 60,
          child: Container(
            padding: EdgeInsets.all(ScreenPadding.padding32px),
            width: ScreenUtil.getWidth(context),
            decoration: BoxDecoration(
              color: DertColor.chart.purple,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeRadius.radius60px),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
