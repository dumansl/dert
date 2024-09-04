import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardInputDropDownButton<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final String? Function(T?)? validator;

  const DashboardInputDropDownButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.value,
    this.validator,
  });

  @override
  State<DashboardInputDropDownButton<T>> createState() =>
      _DashboardInputDropDownButtonState<T>();
}

class _DashboardInputDropDownButtonState<T>
    extends State<DashboardInputDropDownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: widget.items,
      onChanged: widget.onChanged,
      value: widget.value,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      style: DertTextStyle.poppins.t16w400purple,
      validator: widget.validator,
    );
  }
}
