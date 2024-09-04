import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class CustomDermanButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle style;
  const CustomDermanButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.style,
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
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
