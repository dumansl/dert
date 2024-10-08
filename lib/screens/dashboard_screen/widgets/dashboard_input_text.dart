import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardInputText extends StatelessWidget {
  final bool obscureText;

  final String? labelText;
  final Widget? suffixIcon;
  final Color? borderColor;
  final TextStyle? style;
  final void Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;

  const DashboardInputText({
    super.key,
    this.onChanged,
    this.validator,
    this.labelText,
    this.obscureText = false,
    this.suffixIcon,
    this.borderColor,
    this.style,
    this.onSaved,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        border: InputBorder.none,
        labelText: labelText,
        labelStyle: style ?? DertTextStyle.roboto.t14w500darkpurple,
        hintStyle: style ?? DertTextStyle.roboto.t14w500darkpurple,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenPadding.padding16px,
          vertical: ScreenPadding.padding20px,
        ),
        filled: true,
        fillColor:
            borderColor == Colors.white ? DertColor.card.purple : Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeRadius.radius8px),
          borderSide: BorderSide(
            color: borderColor ?? DertColor.card.darkpurple,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? DertColor.card.darkpurple,
          ),
          borderRadius: BorderRadius.circular(SizeRadius.radius8px),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeRadius.radius8px),
          borderSide: BorderSide(
            color: DertColor.frame.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeRadius.radius8px),
          borderSide: BorderSide(
            color: DertColor.frame.error,
            width: 1,
          ),
        ),
      ),
      style: style,
      validator: validator,
    );
  }
}
