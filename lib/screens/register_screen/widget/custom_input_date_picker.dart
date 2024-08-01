import 'package:dert/screens/register_screen/widget/custom_input.dart';
import 'package:flutter/material.dart';

class CustomInputDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomInputDatePicker({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputText(
      controller: controller,
      hintText: hintText,
      suffixIcon: IconButton(
        icon: const Icon(Icons.date_range),
        onPressed: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            controller.text = selectedDate.toLocal().toString().split(' ')[0];
          }
        },
      ),
    );
  }
}
