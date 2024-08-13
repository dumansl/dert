import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class CustomInputDatePicker extends StatelessWidget {
  final VoidCallback onPressed;
  final int birthdate;
  const CustomInputDatePicker(
      {super.key, required this.onPressed, required this.birthdate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: DertText.registerBirthdate,
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
        ),
        child: Text(
          birthdate == 0
              ? DertText.registerBirthdate
              : DateTime.fromMillisecondsSinceEpoch(birthdate * 1000)
                  .toLocal()
                  .toString()
                  .split(' ')[0],
          style: DertTextStyle.poppins.t16w400purple,
        ),
      ),
    );
  }
}
