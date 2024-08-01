import 'package:dert/screens/login_screen/widget/custom_input_text.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/services/shared_preferences_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_button.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({
    super.key,
  });

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  late SharedPreferencesService _sharedPreferencesService;

  final formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _rememberMe = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _sharedPreferencesService = SharedPreferencesService();
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(email, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
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
            child: _loginLogo(context),
          ),
        ),
        Expanded(
          flex: 60,
          child: Container(
            padding: EdgeInsets.all(ScreenPadding.padding32px),
            width: ScreenUtil.getWidth(context),
            decoration: BoxDecoration(
              color: DertColor.chart.purple,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(SizeRadius.radius60px),
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: _loginContent(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginLogo(BuildContext context) {
    return Container(
      width: ScreenUtil.getWidth(context) * 0.5,
      height: ScreenUtil.getHeight(context) * 0.1,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.logo),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _loginContent(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomInputText(
            hintText: DertText.loginEmail,
            keyboardType: TextInputType.emailAddress,
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
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
          SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
          CustomInputText(
            hintText: DertText.loginPassword,
            obscureText: !_showPassword,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            suffixIcon: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
            onSaved: (newValue) {
              _password = newValue!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return DertText.loginValidatorPassword;
              }
              return null;
            },
          ),
          SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) async {
                  setState(() {
                    _rememberMe = value!;
                  });
                  await _sharedPreferencesService.setLoggedIn(_rememberMe);
                },
                side: const BorderSide(color: Colors.white),
              ),
              Text(
                DertText.loginRememberMe,
                style: DertTextStyle.roboto.t16w500white,
              ),
            ],
          ),
          SizedBox(height: ScreenUtil.getHeight(context) * 0.04),
          CustomLoginButton(
            text: DertText.login,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                login(context, _email, _password);
              }
            },
          ),
          SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
              }
            },
            child: Text(
              DertText.loginForgotPassword,
              style: DertTextStyle.roboto.t16w500white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
            child: Text(
              DertText.loginRegister,
              style: DertTextStyle.roboto.t16w500white,
            ),
          ),
        ],
      ),
    );
  }
}
