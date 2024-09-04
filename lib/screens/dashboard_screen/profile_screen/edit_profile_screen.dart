import 'package:dert/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/user_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';

import '../widgets/custom_dashboard_button.dart';
import '../widgets/dashboard_circle_avatar.dart';
import '../widgets/dashboard_input_drop_down.dart';
import '../widgets/dashboard_input_text.dart';
import '../widgets/dert_appbar.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _profileImageUrl;
  bool _isUploadingImage = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showPassword2 = false;
  bool _showPassword3 = false;

  late String _firstname = widget.user.firstName;
  late String _lastname = widget.user.lastName;
  late String _username = widget.user.username;
  late String _gender = widget.user.gender;

  String _oldPassword = "";
  String _password = "";
  String _confirmPassword = "";

  Future<void> _uploadProfileImage() async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      String? imageUrl = await Provider.of<UserService>(context, listen: false)
          .uploadProfileImage(userId: widget.user.uid);
      setState(() {
        _profileImageUrl = imageUrl;
      });
    } catch (e) {
      snackBar(context, "Resim yükleme sırasında bir hata oluştu: $e");
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  Future<void> _updateInformation(UserService userService) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedFields = {};

      if (_firstname != widget.user.firstName) {
        updatedFields['firstName'] = _firstname;
      }
      if (_lastname != widget.user.lastName) {
        updatedFields['lastName'] = _lastname;
      }
      if (_username != widget.user.username) {
        updatedFields['username'] = _username;
      }
      if (_gender != widget.user.gender) {
        updatedFields['gender'] = _gender;
      }

      if (updatedFields.isNotEmpty) {
        try {
          await userService.updateUserFields(
            userId: widget.user.uid,
            updatedFields: updatedFields,
          );
          snackBar(
            context,
            "Bilgiler başarıyla güncellendi.",
            bgColor: DertColor.state.success,
          );
        } catch (e) {
          snackBar(
              context, "Bilgileri güncelleme sırasında bir hata oluştu: $e");
        }
      } else {
        snackBar(context, "Güncellenecek herhangi bir bilgi bulunamadı.");
      }
    }
  }

  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        authService.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        snackBar(context, "Şifre başarıyla değiştirildi.",
            bgColor: DertColor.state.success);
      } catch (e) {
        snackBar(context, "Şifre değiştirme hatası: $e",
            bgColor: DertColor.state.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DertAppbar(
        title: DertText.profileEdit.toUpperCase(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenPadding.padding16px,
            vertical: ScreenPadding.padding16px,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _changePhoto(context),
                  const SizedBox(height: 16),
                  _profileInformation(),
                  const SizedBox(height: 16),
                  CustomDashboardButton(
                    text: DertText.informationUpdate,
                    onPressed: () => _updateInformation(userService),
                  ),
                  const SizedBox(height: 16),
                  _changePasswordContent(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _changePasswordContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DertColor.card.purple,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DertText.changePassword,
                style: DertTextStyle.roboto.t18w700white),
            const SizedBox(height: 16),
            DashboardInputText(
              labelText: DertText.oldPassword,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return DertText.passwordPlease;
                } else if (value.length < 6) {
                  return DertText.passwordCharachter;
                }
                return null;
              },
              onSaved: (newValue) {
                _oldPassword = newValue!;
              },
              obscureText: !_showPassword,
              borderColor: Colors.white,
              style: DertTextStyle.roboto.t14w500white,
            ),
            const SizedBox(height: 16),
            DashboardInputText(
              labelText: DertText.newPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword2 ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword2 = !_showPassword2;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return DertText.passwordPlease;
                } else if (value.length < 6) {
                  return DertText.passwordCharachter;
                }
                return null;
              },
              onSaved: (newValue) {
                _password = newValue!;
              },
              obscureText: !_showPassword2,
              borderColor: Colors.white,
              style: DertTextStyle.roboto.t14w500white,
            ),
            const SizedBox(height: 16),
            DashboardInputText(
              labelText: DertText.confirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword3 ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword3 = !_showPassword3;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return DertText.passwordAgain;
                }
                return null;
              },
              onSaved: (newValue) {
                _confirmPassword = newValue!;
              },
              obscureText: !_showPassword3,
              borderColor: Colors.white,
              style: DertTextStyle.roboto.t14w500white,
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomDashboardButton(
                text: DertText.change,
                onPressed: () {
                  debugPrint(_confirmPassword);
                  _changePassword(_oldPassword, _password);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _profileInformation() {
    return Column(
      children: [
        DashboardInputText(
          initialValue: _firstname,
          labelText: DertText.registerName,
          onChanged: (value) => _firstname = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return DertText.registerValidatorName;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DashboardInputText(
          initialValue: _lastname,
          labelText: DertText.registerSurname,
          onChanged: (value) => _lastname = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return DertText.registerValidatorSurname;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DashboardInputText(
          initialValue: _username,
          labelText: DertText.registerUserName,
          onChanged: (value) => _username = value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return DertText.registerValidatorUsername;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DashboardInputDropDownButton<String>(
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
          value: _gender.isNotEmpty ? _gender : null,
          onChanged: (value) => setState(() {
            _gender = value!;
          }),
          hintText: DertText.registerGender,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return DertText.registerValidatorGender;
            }
            return null;
          },
        )
      ],
    );
  }

  SizedBox _changePhoto(BuildContext context) {
    return SizedBox(
      height: ScreenUtil.getWidth(context) * 0.25,
      width: ScreenUtil.getWidth(context) * 0.25,
      child: Stack(
        children: [
          DashboardCircleAvatar(
            profileImageUrl: _profileImageUrl ?? widget.user.profileImageUrl,
            gender: widget.user.gender,
            radius: 50,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: _uploadProfileImage,
              child: Container(
                width: IconSize.size35px,
                height: IconSize.size35px,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      ImagePath.changePhotoLogo,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isUploadingImage)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
