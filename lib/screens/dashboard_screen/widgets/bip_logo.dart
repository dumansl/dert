import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class BipLogo extends StatelessWidget {
  final double radius;
  const BipLogo({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.bipLogo),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}
