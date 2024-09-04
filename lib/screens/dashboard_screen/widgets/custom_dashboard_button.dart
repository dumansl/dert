import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class CustomDashboardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  const CustomDashboardButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
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
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              text,
              style: DertTextStyle.roboto.t20w500white,
            ),
    );
  }
}
