import 'package:dert/screens/login_screens/register/widgets/register_divider.dart';
import 'package:dert/screens/login_screens/widgets/custom_button.dart';
import 'package:dert/screens/login_screens/widgets/custom_input_drop_down.dart';
import 'package:dert/screens/login_screens/widgets/custom_input_text.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_input_date_picker.dart';

class ProfileContent extends StatefulWidget {
  final Function(String, String, int) onProfileEntered;

  const ProfileContent({super.key, required this.onProfileEntered});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _gender = '';
  String? _profileImageUrl;
  int _birthdate = 0;

  Future<void> _selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _birthdate = picked.millisecondsSinceEpoch ~/ 1000;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const RegisterDivider(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : null,
                  child: _profileImageUrl == null
                      ? IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () async {
                            String? imageUrl = await Provider.of<AuthService>(
                                    context,
                                    listen: false)
                                .uploadProfileImage();
                            setState(() {
                              _profileImageUrl = imageUrl;
                            });
                          },
                        )
                      : null,
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
                CustomInputDatePicker(
                  onPressed: () => _selectBirthdate(context),
                  birthdate: _birthdate,
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
          ),
        ],
      ),
    );
  }
}
