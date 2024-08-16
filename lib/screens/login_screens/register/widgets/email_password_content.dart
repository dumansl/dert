import 'package:dert/screens/login_screens/register/widgets/register_divider.dart';
import 'package:dert/screens/login_screens/widgets/custom_button.dart';
import 'package:dert/screens/login_screens/widgets/custom_input_text.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';

class EmailPasswordContent extends StatefulWidget {
  final Function(String, String, String) onEmailPasswordEntered;

  const EmailPasswordContent({super.key, required this.onEmailPasswordEntered});
  @override
  State<EmailPasswordContent> createState() => _EmailPasswordContentState();
}

class _EmailPasswordContentState extends State<EmailPasswordContent> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const RegisterDivider(),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomInputText(
                      keyboardType: TextInputType.emailAddress,
                      hintText: DertText.registerEmail,
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
                          return DertText.registerValidatorEmail;
                        } else if (!value.contains('@')) {
                          return DertText.registerValidatorEmailV2;
                        }
                        return null;
                      },
                    ),
                    CustomInputText(
                      hintText: DertText.registerPassword,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocusNode);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: DertColor.button.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return DertText.registerValidatorPassword;
                        } else if (value.length < 6) {
                          return DertText.registerValidatorPasswordV2;
                        }
                        return null;
                      },
                      obscureText: !_showPassword,
                      onSaved: (newValue) {
                        _password = newValue!;
                      },
                    ),
                    CustomInputText(
                      hintText: DertText.registerPasswordAgain,
                      focusNode: _confirmPasswordFocusNode,
                      textInputAction: TextInputAction.done,
                      obscureText: !_showConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: DertColor.button.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                      onSaved: (newValue) {
                        _confirmPassword = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return DertText.registerValidatorConfirmPassword;
                        }
                        return null;
                      },
                    ),
                    CustomLoginButton(
                      text: DertText.registerNext,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (_password != _confirmPassword) {
                            snackBar(
                                context, DertText.registerConfirmPasswordError);
                            return;
                          }
                          widget.onEmailPasswordEntered(
                              _email, _password, _confirmPassword);
                        }
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
