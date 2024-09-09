import 'package:dert/screens/dashboard_screen/widgets/custom_dashboard_button.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_input_drop_down.dart';
import 'package:dert/screens/dashboard_screen/widgets/dashboard_input_text.dart';
import 'package:dert/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dert/model/user_model.dart';
import 'package:dert/services/user_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';

import '../widgets/dashboard_circle_avatar.dart';
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

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  String? _gender;

  bool _showPassword = false;
  bool _showPassword2 = false;
  bool _showPassword3 = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _usernameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _gender = widget.user.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      await authService.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);

      snackBar(context, "Şifre başarıyla değiştirildi.",
          bgColor: DertColor.state.success);

      _passwordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      snackBar(
        context,
        "Şifre değiştirme hatası: $e",
        bgColor: DertColor.state.error,
      );
    }
  }

  Future<void> _saveProfile() async {
    final userService = Provider.of<UserService>(context, listen: false);
    try {
      await userService.updateUserProfile(
        userId: widget.user.uid,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        gender: _gender ?? widget.user.gender,
      );
      snackBar(
        context,
        "Bilgiler başarıyla güncellendi.",
        bgColor: DertColor.state.success,
      );
    } catch (e) {
      snackBar(
        context,
        "Bilgiler güncellenmedi $e",
      );
    }
  }

  Future<void> _uploadProfileImage() async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      String? imageUrl = await Provider.of<UserService>(context, listen: false)
          .uploadProfileImage(userId: widget.user.uid);

      if (imageUrl != null) {
        setState(() {
          _profileImageUrl = imageUrl;
        });

        snackBar(
          context,
          "Profil resmi başarıyla yüklendi!",
          bgColor: DertColor.state.success,
        );
      } else {
        snackBar(context, "Profil resmi seçilmedi.");
      }
    } catch (e) {
      snackBar(context, "Profil resmi yüklenirken bir hata oluştu.");
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _changePhoto(context),
                const SizedBox(height: 16),
                _profileInformation(),
                const SizedBox(height: 16),
                CustomDashboardButton(
                  text: DertText.informationUpdate,
                  onPressed: () => _saveProfile(),
                ),
                const SizedBox(height: 16),
                _changePasswordContent(context)
              ],
            ),
          ),
        ),
      ),
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

  Widget _profileInformation() {
    return Column(
      children: [
        DashboardInputText(
          controller: _firstNameController,
          labelText: DertText.registerName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return DertText.registerValidatorName;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DashboardInputText(
          controller: _lastNameController,
          labelText: DertText.registerSurname,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return DertText.registerValidatorSurname;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DashboardInputText(
          controller: _usernameController,
          labelText: DertText.registerUserName,
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
          value: _gender!.isNotEmpty ? _gender : null,
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

  Widget _changePasswordContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DertColor.card.purple,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DertText.changePassword,
              style: DertTextStyle.roboto.t18w700white),
          const SizedBox(height: 16),
          DashboardInputText(
            labelText: DertText.oldPassword,
            controller: _passwordController,
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
            obscureText: !_showPassword,
            borderColor: Colors.white,
            style: DertTextStyle.roboto.t14w500white,
          ),
          const SizedBox(height: 16),
          DashboardInputText(
            labelText: DertText.newPassword,
            controller: _newPasswordController,
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
            obscureText: !_showPassword2,
            borderColor: Colors.white,
            style: DertTextStyle.roboto.t14w500white,
          ),
          const SizedBox(height: 16),
          DashboardInputText(
            labelText: DertText.confirmPassword,
            controller: _confirmPasswordController,
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
              } else if (value != _newPasswordController.text) {
                return DertText.registerConfirmPasswordError;
              }
              return null;
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
                if (_newPasswordController.text !=
                    _confirmPasswordController.text) {
                  snackBar(context, DertText.registerConfirmPasswordError);
                  return;
                } else {
                  _changePassword(
                      _passwordController.text, _newPasswordController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
