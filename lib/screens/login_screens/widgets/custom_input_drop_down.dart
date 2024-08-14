import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class CustomInputDropDownButton<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final String? Function(T?)? validator;

  const CustomInputDropDownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.value,
    this.validator,
  });

  @override
  State<CustomInputDropDownButton<T>> createState() =>
      _CustomInputDropDownButtonState<T>();
}

class _CustomInputDropDownButtonState<T>
    extends State<CustomInputDropDownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: widget.items,
      onChanged: widget.onChanged,
      value: widget.value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: widget.hintText,
      ),
      style: DertTextStyle.poppins.t16w400purple,
      validator: widget.validator,
    );
  }
}
