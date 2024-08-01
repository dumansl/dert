import 'package:dert/screens/screens.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/services/shared_preferences_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/custom_button.dart';
import 'widget/custom_input_text.dart';

class LoginContentDesktop extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onPressed;
  const LoginContentDesktop({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onPressed,
  });

  @override
  State<LoginContentDesktop> createState() => _LoginContentDesktopState();
}

class _LoginContentDesktopState extends State<LoginContentDesktop> {
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
    return Row(
      children: [
        Expanded(
          flex: 60,
          child: Center(
            child: _loginLogo(context),
          ),
        ),
        Expanded(
          flex: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            width: ScreenUtil.getWidth(context),
            color: DertColor.chart.purple,
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
                color: DertColor.button.purple,
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
            onPressed: () {},
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

  Widget _loginLogo(BuildContext context) {
    return Container(
      width: ScreenUtil.getWidth(context) * 0.6,
      height: ScreenUtil.getHeight(context) * 0.2,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.logo),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
