import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Typography {
  final TextStyle baseStyle;
  final TextStyle t24w600darkpurple;
  final TextStyle t24w400purple;
  final TextStyle t24w400white;
  final TextStyle t20w600darkPurple;
  final TextStyle t20w500darkpurple;
  final TextStyle t20w500white;
  final TextStyle t18w700purple;
  final TextStyle t18w700darkpurple;
  final TextStyle t16w700darkpurple;
  final TextStyle t16w600darkPurple;
  final TextStyle t16w500darkpurple;
  final TextStyle t16w500white;
  final TextStyle t16w400purple;
  final TextStyle t16w400lightPurple;
  final TextStyle t14w500darkpurple;
  final TextStyle t14w700purple;
  final TextStyle t14w400white;
  final TextStyle t14w400purple;
  final TextStyle t12w500white;
  final TextStyle t12w400white;
  final TextStyle t10w400green;
  final TextStyle t10w800grey;
  Typography({required this.baseStyle})
      : t24w600darkpurple = baseStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: DertColor.text.darkpurple,
        ),
        t24w400purple = baseStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: DertColor.text.purple,
        ),
        t24w400white = baseStyle.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        t20w500darkpurple = baseStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: DertColor.text.darkpurple,
        ),
        t18w700purple = baseStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: DertColor.text.purple,
        ),
        t18w700darkpurple = baseStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: DertColor.text.darkpurple,
        ),
        t16w400purple = baseStyle.copyWith(
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
        t16w500darkpurple = baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: DertColor.text.darkpurple,
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
        t16w600darkPurple = baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: DertColor.text.darkpurple,
        ),
        t16w700darkpurple = baseStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: DertColor.text.darkpurple,
        ),
        t14w700purple = baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: DertColor.text.purple,
        ),
        t14w500darkpurple = baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: DertColor.text.darkpurple,
        ),
        t14w400white = baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        t14w400purple = baseStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: DertColor.text.purple,
        ),
        t12w400white = baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        t12w500white = baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        t10w800grey = baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: DertColor.text.grey,
        ),
        t10w400green = baseStyle.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: DertColor.text.green,
        );
}

abstract class DertTextStyle {
  static Typography montserrat =
      Typography(baseStyle: GoogleFonts.montserrat());
  static Typography poppins = Typography(baseStyle: GoogleFonts.poppins());
  static Typography inter = Typography(baseStyle: GoogleFonts.inter());
  static Typography roboto = Typography(baseStyle: GoogleFonts.roboto());
}
