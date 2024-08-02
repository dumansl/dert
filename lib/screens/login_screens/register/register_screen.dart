import 'package:dert/screens/login_screens/register/register_content.dart';
import 'package:dert/screens/login_screens/widget/basic_appbar.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'register_content_desktop.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppBar(
        title: DertText.register,
        backgroundColor: Colors.transparent,
        style: DertTextStyle.inter.t20w600darkPurple,
        isLeadingVisible: true,
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
            ? const RegisterContentDesktop()
            : const RegisterContent(),
      ),
    );
  }
}
