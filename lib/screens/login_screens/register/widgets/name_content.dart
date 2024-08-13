import 'package:dert/screens/login_screens/widgets/custom_button.dart';
import 'package:dert/screens/login_screens/widgets/custom_input_text.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'register_divider.dart';

class NameContent extends StatefulWidget {
  final Function(String, String) onNameEntered;

  const NameContent({super.key, required this.onNameEntered});

  @override
  State<NameContent> createState() => _NameContentState();
}

class _NameContentState extends State<NameContent> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

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
                    hintText: DertText.registerName,
                    focusNode: _nameFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_lastNameFocusNode);
                    },
                    onSaved: (newValue) {
                      _firstName = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return DertText.registerValidatorName;
                      }
                      return null;
                    },
                  ),
                  CustomInputText(
                    hintText: DertText.registerSurname,
                    focusNode: _lastNameFocusNode,
                    textInputAction: TextInputAction.done,
                    onSaved: (newValue) {
                      _lastName = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return DertText.registerValidatorSurname;
                      }
                      return null;
                    },
                  ),
                  Text(
                    DertText.registerDescription,
                    style: DertTextStyle.roboto.t14w400white,
                  ),
                  CustomLoginButton(
                    text: DertText.registerNext,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.onNameEntered(_firstName, _lastName);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
