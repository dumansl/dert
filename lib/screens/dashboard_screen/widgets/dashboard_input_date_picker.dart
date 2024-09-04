import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class DashboardInputDatePicker extends StatelessWidget {
  final VoidCallback onPressed;
  final int birthdate;
  final FormFieldValidator<int>? validator;
  const DashboardInputDatePicker(
      {super.key,
      required this.onPressed,
      required this.birthdate,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      validator: validator,
      builder: (FormFieldState<int> state) {
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SizeRadius.radius8px),
                borderSide: BorderSide(
                  color: DertColor.frame.error,
                  width: 1,
                ),
              ),
              errorText: state.hasError ? state.errorText : null,
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
      },
      initialValue: birthdate,
    );
  }
}
