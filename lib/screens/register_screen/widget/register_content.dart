import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'complete_register_form.dart';
import 'register_first_form.dart';

class RegisterContent extends StatefulWidget {
  const RegisterContent({
    super.key,
  });

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final PageController pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Ekranın alt kısmını kaydır
    if (_scrollController.offset > 0 &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.isDesktop(context)
        ? _buildDesktopContent()
        : _buildMobileContent();
  }

  Widget _buildDesktopContent() {
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
              child: PageView(
                controller: pageController,
                children: [
                  RegisterFirstForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    onPressed: () {
                      pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  CompleteRegisterForm(
                    onPressed: () => () {},
                    birthDateController: birthDateController,
                    userNameController: userNameController,
                    genderController: genderController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: SizedBox(
        height: ScreenUtil.getHeight(context),
        child: Column(
          children: [
            Expanded(
              flex: 40,
              child: Center(
                child: Container(
                  width: ScreenUtil.getWidth(context) * 0.5,
                  height: ScreenUtil.getHeight(context) * 0.1,
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
              flex: 60,
              child: Container(
                padding: const EdgeInsets.all(32),
                width: ScreenUtil.getWidth(context),
                decoration: BoxDecoration(
                  color: DertColor.chart.purple,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Center(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      RegisterFirstForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        onPressed: () {
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      CompleteRegisterForm(
                        onPressed: () => () {},
                        birthDateController: birthDateController,
                        userNameController: userNameController,
                        genderController: genderController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
