import 'package:dert/screens/login_screens/widgets/custom_logo.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_text.dart';

class PasswordResetContentDesktop extends StatefulWidget {
  const PasswordResetContentDesktop({
    super.key,
  });

  @override
  State<PasswordResetContentDesktop> createState() =>
      _PasswordResetContentDesktopState();
}

class _PasswordResetContentDesktopState
    extends State<PasswordResetContentDesktop> {
  final formKey = GlobalKey<FormState>();
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 60,
          child: Center(
            child: CustomLogo(
              width: ScreenUtil.getWidth(context) * 0.6,
              height: ScreenUtil.getHeight(context) * 0.2,
            ),
          ),
        ),
        Expanded(
          flex: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            width: ScreenUtil.getWidth(context),
            color: DertColor.card.purple,
            child: Center(
              child: SingleChildScrollView(
                child: _passwordResetContent(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordResetContent(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomInputText(
            hintText: DertText.loginEmail,
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) {
              _email = newValue!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return DertText.loginValidatorEmail;
              }

              return null;
            },
          ),
          SizedBox(height: ScreenUtil.getHeight(context) * 0.04),
          CustomLoginButton(
            text: DertText.passwordForgotSend,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                debugPrint(_email);
              }
            },
          ),
        ],
      ),
    );
  }
}
