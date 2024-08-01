import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputText extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;

  const CustomInputText({
    super.key,
    this.obscureText = false,
    required this.hintText,
    required this.controller,
    this.suffixIcon,
  });

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  final bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText && !_showPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
        ),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          color: DertColor.text.purple,
        ),
      ),
    );
  }
}

class CustomInputDropDownButton<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String hintText;

  const CustomInputDropDownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.value,
  });

  @override
  State<CustomInputDropDownButton<T>> createState() =>
      _CustomInputDropDownButtonState<T>();
}

class _CustomInputDropDownButtonState<T>
    extends State<CustomInputDropDownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: DropdownButtonFormField<T>(
        items: widget.items,
        onChanged: widget.onChanged,
        value: widget.value,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          color: DertColor.text.purple,
        ),
      ),
    );
  }
}
