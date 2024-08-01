import 'package:dert/screens/login_screen/widget/basic_appbar.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widget/login_content.dart';
import 'widget/login_content_desktop.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppBar(
        title: DertText.login,
        backgroundColor: Colors.transparent,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: DertColor.text.darkpurple,
        ),
        isLeadingVisible: false,
      ),
      body: Container(
        width: ScreenUtil.getWidth(context),
        height: ScreenUtil.getHeight(context),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.loginBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: ResponsiveBuilder.isDesktop(context)
            ? LoginContentDesktop(
                emailController: _emailController,
                passwordController: _passwordController,
                onPressed: () => () {},
              )
            : const LoginContent(),
      ),
    );
  }
}
