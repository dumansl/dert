import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class CustomDermanButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CustomDermanButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: DertColor.button.darkpurple,
        elevation: 0,
        fixedSize: Size(
            ScreenUtil.getWidth(context), ScreenUtil.getHeight(context) * 0.07),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
