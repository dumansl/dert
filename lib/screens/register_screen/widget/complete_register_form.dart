import 'package:dert/screens/register_screen/widget/custom_input.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_input_date_picker.dart';

class CompleteRegisterForm extends StatefulWidget {
  final TextEditingController userNameController;
  final TextEditingController genderController;

  final TextEditingController birthDateController;
  final Function onPressed;
  const CompleteRegisterForm({
    super.key,
    required this.onPressed,
    required this.userNameController,
    required this.genderController,
    required this.birthDateController,
  });

  @override
  State<CompleteRegisterForm> createState() => _CompleteRegisterFormState();
}

class _CompleteRegisterFormState extends State<CompleteRegisterForm> {
  bool _validateFields(BuildContext context) {
    if (widget.userNameController.text.isEmpty) {
      snackBar(context, "Lütfen kullanıcı isminizi giriniz.");
      return false;
    } else if (widget.genderController.text.isEmpty) {
      snackBar(context, "Lütfen cinsiyet alanını doldurun.");
      return false;
    } else if (widget.birthDateController.text.isEmpty) {
      snackBar(context, "Lütfen doğum tarihinizi giriniz.");
      return false;
    }
    // else if (!_isUserOldEnough()) {
    //   snackBar(
    //       context, "");
    //   return false;
    // }
    return true;
  }

  // bool _isUserOldEnough() {
  //   DateTime birthDate = DateTime.parse(widget.birthDateController.text.trim());
  //   DateTime currentDate = DateTime.now();
  //   int age = currentDate.year - birthDate.year;

  //   if (currentDate.month < birthDate.month ||
  //       (currentDate.month == birthDate.month &&
  //           currentDate.day < birthDate.day)) {
  //     age--;
  //   }
  //   return age >= 18;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomInputText(
          controller: widget.userNameController,
          hintText: "Kullanıcı Adı",
        ),
        const SizedBox(height: 16),
        CustomInputDropDownButton<String>(
          items: const [
            DropdownMenuItem(value: 'Kadın', child: Text('Kadın')),
            DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
            DropdownMenuItem(value: 'Diğer', child: Text('Diğer')),
          ],
          onChanged: (value) {
            widget.genderController.text = value!;
          },
          hintText: 'Cinsiyet',
        ),
        const SizedBox(height: 16),
        CustomInputDatePicker(
          controller: widget.birthDateController,
          hintText: "Doğum Günü",
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: DertColor.button.darkpurple,
            elevation: 0,
            fixedSize: Size(
              ScreenUtil.getWidth(context),
              ScreenUtil.getHeight(context) * 0.07,
            ),
          ),
          onPressed: () {
            if (_validateFields(context)) {
              widget.onPressed();
            }
          },
          child: Text(
            "TAMAMLA",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
