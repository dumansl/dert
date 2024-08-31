import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class AlertButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  const AlertButton({super.key, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        ImagePath.alertLogo,
        height: size,
        width: size,
      ),
    );
  }
}
