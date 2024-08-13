import 'package:dert/screens/login_screens/register/widgets/email_password_content.dart';
import 'package:dert/screens/login_screens/register/widgets/name_content.dart';
import 'package:dert/screens/login_screens/register/widgets/profile_content.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

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

  void _onProfileEntered(String username, String gender, int birthdate) {
    setState(() {
      _username = username;
      _gender = gender;
      _birthdate = birthdate;
    });
    debugPrint('Kayıt Tamamlandı');
    debugPrint('İsim: $_firstName $_lastName');
    debugPrint('İsim: $_password');
    debugPrint('E-posta: $_email');
    debugPrint('Kullanıcı Adı: $_username');
    debugPrint('Cinsiyet: $_gender');
    debugPrint('Doğum Tarihi: $_birthdate');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 60,
          child: Center(
            child: Container(
              width: ScreenUtil.getWidth(context) * 0.6,
              height: ScreenUtil.getHeight(context) * 0.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImagePath.logo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            width: ScreenUtil.getWidth(context),
            color: DertColor.chart.purple,
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                NameContent(onNameEntered: _onNameEntered),
                EmailPasswordContent(
                    onEmailPasswordEntered: _onEmailPasswordEntered),
                ProfileContent(onProfileEntered: _onProfileEntered),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
