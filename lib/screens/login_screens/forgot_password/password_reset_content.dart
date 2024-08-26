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

class PasswordResetContent extends StatefulWidget {
  const PasswordResetContent({
    super.key,
  });

  @override
  State<PasswordResetContent> createState() => _PasswordResetContentState();
}

class _PasswordResetContentState extends State<PasswordResetContent> {
  final formKey = GlobalKey<FormState>();
  late String _email;

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
    return Column(
      children: [
        Expanded(
          flex: 40,
          child: Center(
            child: CustomLogo(
              width: ScreenUtil.getWidth(context) * 0.5,
              height: ScreenUtil.getHeight(context) * 0.1,
            ),
          ),
        ),
        Expanded(
          flex: 60,
          child: Container(
            padding: EdgeInsets.all(ScreenPadding.padding32px),
            width: ScreenUtil.getWidth(context),
            decoration: BoxDecoration(
              color: DertColor.card.purple,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeRadius.radius60px),
              ),
            ),
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
