import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/widgets.dart';

class CustomLogo extends StatelessWidget {
  final double height;
  final double width;
  const CustomLogo({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.logo),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
