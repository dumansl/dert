import 'package:dert/screens/login_screens/widget/basic_appbar.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'login_content.dart';
import 'login_content_desktop.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppBar(
        title: DertText.login,
        backgroundColor: Colors.transparent,
        style: DertTextStyle.inter.t20w600darkPurple,
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
            ? const LoginContentDesktop()
            : const LoginContent(),
      ),
    );
  }
}
