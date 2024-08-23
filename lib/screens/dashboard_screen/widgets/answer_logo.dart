import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class AnswerLogo extends StatelessWidget {
  final double radius;
  const AnswerLogo({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
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
