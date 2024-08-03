import 'package:auto_size_text/auto_size_text.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    this.title = "",
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Center(
          child: Image.asset(
            image,
            height: ScreenUtil.getHeight(context) * 0.55,
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),
        AutoSizeText(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: DertColor.text.purple,
          ),
        ),
        const SizedBox(height: 16),
        AutoSizeText(
          description,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: DertColor.text.purple,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
