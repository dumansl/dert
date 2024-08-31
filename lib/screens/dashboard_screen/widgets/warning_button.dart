import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class WarningButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  const WarningButton({super.key, required this.onPressed, required this.size});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        ImagePath.warningLogo,
        height: size,
        width: size,
      ),
    );
  }
}
