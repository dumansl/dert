import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Typography {
  final TextStyle baseStyle;
  final TextStyle t16w400purple;
  final TextStyle t16w400lightPurple;
  final TextStyle t16w500white;
  final TextStyle t20w600darkPurple;
  final TextStyle t20w500white;
  final TextStyle t14w400white;

  Typography({required this.baseStyle})
      : t16w400purple = baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DertColor.text.purple,
        ),
        t16w400lightPurple = baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DertColor.text.lightpurple,
        ),
        t16w500white = baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        t20w600darkPurple = baseStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: DertColor.text.darkpurple,
        ),
        t20w500white = baseStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        t14w400white = baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        );
}

abstract class DertTextStyle {
  static Typography montserrat =
      Typography(baseStyle: GoogleFonts.montserrat());
  static Typography poppins = Typography(baseStyle: GoogleFonts.poppins());
  static Typography inter = Typography(baseStyle: GoogleFonts.inter());
  static Typography roboto = Typography(baseStyle: GoogleFonts.roboto());
}
