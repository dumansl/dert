import 'package:dert/screens/login_screens/register/widgets/email_password_content.dart';
import 'package:dert/screens/login_screens/register/widgets/name_content.dart';
import 'package:dert/screens/login_screens/register/widgets/profile_content.dart';
import 'package:dert/services/auth_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:dert/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterContent extends StatefulWidget {
  const RegisterContent({super.key});

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
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

  void _onProfileEntered(String username, String gender, int birthdate) async {
    setState(() {
      _username = username;
      _gender = gender;
      _birthdate = birthdate;
    });

    try {
      // Kullanıcı kaydını gerçekleştir
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
        // Kayıt başarılı, kullanıcıyı yönlendir
        debugPrint('Kayıt Tamamlandı');
        debugPrint('İsim: $_firstName $_lastName');
        debugPrint('E-posta: $_email');
        debugPrint('Kullanıcı Adı: $_username');
        debugPrint('Cinsiyet: $_gender');
        debugPrint('Doğum Tarihi: $_birthdate');
        // Örneğin, anasayfaya yönlendirme yapabilirsiniz
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint("Kayıt sırasında bir hata oluştu: $e");
      snackBar(context, "Kayıt sırasında bir hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 40,
          child: Center(
            child: Container(
              width: ScreenUtil.getWidth(context) * 0.5,
              height: ScreenUtil.getHeight(context) * 0.1,
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
