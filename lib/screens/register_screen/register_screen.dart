import 'package:dert/screens/register_screen/widget/basic_appbar.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widget/register_content.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: BasicAppBar(
        title: "KAYIT OL",
        backgroundColor: Colors.transparent,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: DertColor.text.darkpurple,
        ),
        isLeadingVisible: true,
      ),
      body: Container(
        width: ScreenUtil.getWidth(context),
        height: ScreenUtil.getHeight(context),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_screen.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: const RegisterContent(),
      ),
    );
  }
}
