import 'package:dert/screens/login_screens/login/login_screen.dart';
import 'package:dert/screens/login_screens/register/widgets/email_password_content.dart';
import 'package:dert/screens/login_screens/register/widgets/name_content.dart';
import 'package:dert/screens/login_screens/register/widgets/profile_content.dart';
import 'package:dert/screens/login_screens/widgets/custom_logo.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterContentDesktop extends StatefulWidget {
  const RegisterContentDesktop({super.key});

  @override
  State<RegisterContentDesktop> createState() => _RegisterContentDesktopState();
}

class _RegisterContentDesktopState extends State<RegisterContentDesktop> {
  final PageController pageController = PageController();
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _password;
  late String _username;
  late String _gender;
  late int _birthdate;

  bool _isLoading = false;

  void _onNameEntered(String firstName, String lastName) {
    setState(() {
      _firstName = firstName;
      _lastName = lastName;
    });
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onEmailPasswordEntered(
      String email, String password, String confirmPassword) {
    setState(() {
      _email = email;
      _password = password;
    });
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onProfileEntered(String username, String gender, int birthdate) async {
    setState(() {
      _username = username;
      _gender = gender;
      _birthdate = birthdate;
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.createUserWithEmailAndPassword(
        name: _firstName,
        lastName: _lastName,
        email: _email,
        password: _password,
        username: _username,
        gender: _gender,
        birthdate: _birthdate,
      );

      if (user != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        snackBar(context, "Başarıyla kayıt olundu. Lütfen giriş yapınız.",
            bgColor: DertColor.state.success);
      }
    } catch (e) {
      snackBar(context, "$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                NameContent(onNameEntered: _onNameEntered),
                EmailPasswordContent(
                    onEmailPasswordEntered: _onEmailPasswordEntered),
                ProfileContent(
                  onProfileEntered: _onProfileEntered,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
