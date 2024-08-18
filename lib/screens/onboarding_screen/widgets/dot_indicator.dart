import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive
          ? ScreenUtil.getHeight(context) * 0.03
          : ScreenUtil.getHeight(context) * 0.01,
      width: ScreenUtil.getWidth(context) * 0.02,
      decoration: BoxDecoration(
          color: isActive
              ? DertColor.card.purple
              : DertColor.card.purple.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}
