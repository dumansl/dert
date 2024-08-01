import 'package:dert/screens/screens.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_input_text.dart';

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
  bool _rememberMe = false;
  bool _showPassword = false;
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
                  image: AssetImage("assets/images/logo.webp"),
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomInputText(
                      // controller: widget.emailController,
                      hintText: "E-posta Adresi",
                    ),
                    SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
                    CustomInputText(
                      // controller: widget.passwordController,
                      hintText: "Şifre",
                      obscureText: !_showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: DertColor.text.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
                    // TO DO : Beni hatırla işlevselliği kazandır
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          side: const BorderSide(color: Colors.white),
                        ),
                        Text(
                          'Beni Hatırla',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.getHeight(context) * 0.04),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), //
                        ),
                        backgroundColor: DertColor.button.darkpurple,
                        elevation: 0,
                        fixedSize: Size(ScreenUtil.getWidth(context),
                            ScreenUtil.getHeight(context) * 0.07),
                      ),
                      onPressed: widget.onPressed,
                      child: Text(
                        "GİRİŞ YAP",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil.getHeight(context) * 0.02),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Şifremi Unuttum",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
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
                        'Kayıt Ol !',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
