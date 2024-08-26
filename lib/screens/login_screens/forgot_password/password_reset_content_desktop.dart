import 'package:dert/screens/login_screens/widgets/custom_button.dart';
import 'package:dert/screens/login_screens/widgets/custom_input_text.dart';
import 'package:dert/screens/login_screens/widgets/custom_logo.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/horizontal_page_route.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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

  Future<void> resetPassword(BuildContext context, String email) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.resetPassword(email);
      Navigator.push(
        context,
        createHorizontalPageRoute(const LoginScreen()),
      );
      snackBar(
          context, "Şifre sıfırlama işlemi başarılı, mailinizi kontrol ediniz.",
          bgColor: DertColor.state.success);
    } catch (error) {
      snackBar(context, error.toString());
    }
  }

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
            text: DertText.send,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                resetPassword(context, _email);
              }
            },
          ),
        ],
      ),
    );
  }
}
