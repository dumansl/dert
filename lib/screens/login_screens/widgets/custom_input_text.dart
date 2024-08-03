import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class CustomInputText extends StatefulWidget {
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  const CustomInputText({
    super.key,
    this.obscureText = false,
    required this.hintText,
    this.suffixIcon,
    this.keyboardType,
    this.onSaved,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        hintStyle: DertTextStyle.poppins.t16w400lightPurple,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenPadding.padding16px,
          vertical: ScreenPadding.padding20px,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onPrimary,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeRadius.radius8px),
        ),
        focusedBorder: OutlineInputBorder(
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
      style: DertTextStyle.poppins.t16w400purple,
      validator: widget.validator,
    );
  }
}
