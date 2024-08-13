import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class RegisterDivider extends StatelessWidget {
  const RegisterDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenPadding.padding16px),
      padding: EdgeInsets.all(ScreenPadding.padding3px),
      decoration: BoxDecoration(
        color: DertColor.frame.white,
        borderRadius: BorderRadius.all(Radius.circular(SizeRadius.radius16px)),
      ),
    );
  }
}
