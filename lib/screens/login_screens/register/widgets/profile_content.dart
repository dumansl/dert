import 'package:dert/screens/login_screens/widgets/custom_button.dart';
import 'package:dert/screens/login_screens/widgets/custom_input_drop_down.dart';
import 'package:dert/screens/login_screens/widgets/custom_input_text.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

class ProfileContent extends StatefulWidget {
  final Function(String, String, String) onProfileEntered;

  const ProfileContent({super.key, required this.onProfileEntered});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _gender = '';
  String _birthdate = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          CustomInputText(
            hintText: DertText.registerUserName,
            onSaved: (newValue) {
              _username = newValue!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return DertText.registerValidatorUsername;
              }
              return null;
            },
          ),
          CustomInputDropDownButton<String>(
            items: [
              DropdownMenuItem(
                  value: DertText.registerGenderFemale,
                  child: Text(DertText.registerGenderFemale)),
              DropdownMenuItem(
                  value: DertText.registerGenderMale,
                  child: Text(DertText.registerGenderMale)),
              DropdownMenuItem(
                value: DertText.registerGenderOther,
                child: Text(
                  DertText.registerGenderOther,
                ),
              ),
            ],
            onChanged: (value) {
              _gender = value!;
            },
            hintText: DertText.registerGender,
            validator: (value) {
              if (value == null) {
                return DertText.registerValidatorGender;
              }
              return null;
            },
          ),
          CustomLoginButton(
            text: DertText.registerComplete,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onProfileEntered(_username, _gender, _birthdate);
              }
            },
          ),
        ],
      ),
    );
  }
}
