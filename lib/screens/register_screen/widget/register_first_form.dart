import 'package:dert/screens/register_screen/widget/custom_input.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterFirstForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Function() onPressed;
  const RegisterFirstForm(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.onPressed});

  bool _validateFields(BuildContext context) {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      snackBar(
        context,
        "Lütfen tüm alanları doldurun.",
      );
      return false;
    } else if (!_isValidEmail(emailController.text)) {
      snackBar(
        context,
        "Geçerli bir e-posta adresi girin.",
      );
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      snackBar(
        context,
        "Şifreler eşleşmiyor.",
      );
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomInputText(
          controller: emailController,
          hintText: "E-posta Adresi",
        ),
        SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
        CustomInputText(
          controller: passwordController,
          hintText: "Şifre",
        ),
        SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
        CustomInputText(
          controller: confirmPasswordController,
          hintText: "Şifre Onayla",
        ),
        SizedBox(height: ScreenUtil.getHeight(context) * 0.04),
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
              onPressed();
            }
          },
          child: Text(
            "KAYIT OL",
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
