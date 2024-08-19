import 'package:dert/screens/login_screens/widgets/basic_appbar.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';

import 'password_reset_content.dart';
import 'password_reset_content_desktop.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppBar(
        title: DertText.passwordForgot,
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
            ? const PasswordResetContentDesktop()
            : const PasswordResetContent(),
      ),
    );
  }
}
