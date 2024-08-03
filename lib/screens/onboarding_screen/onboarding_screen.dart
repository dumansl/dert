import 'package:auto_size_text/auto_size_text.dart';
import 'package:dert/screens/screens.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/onboard_model.dart';
import 'widgets/dot_indicator.dart';
import 'widgets/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<OnBoard> data = [
    OnBoard(
      image: ImagePath.onboardImage,
      title: DertText.onboardTitle,
      description: DertText.onboardDescription,
    ),
    OnBoard(
      image: ImagePath.onboardImage2,
      title: "",
      description: DertText.onboardDescription2,
    ),
    OnBoard(
      image: ImagePath.onboardImage3,
      title: "",
      description: DertText.onboardDescription3,
    )
  ];

  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHomepage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 85,
                child: PageView.builder(
                  itemCount: data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(
                      () {
                        _pageIndex = index;
                      },
                    );
                  },
                  itemBuilder: (context, index) => OnboardContent(
                    image: data[index].image,
                    title: data[index].title,
                    description: data[index].description,
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Row(
                  children: [
                    ...List.generate(
                      data.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: DotIndicator(isActive: index == _pageIndex),
                      ),
                    ),
                    const Spacer(),
                    _pageIndex == data.length - 1
                        ? SizedBox(
                            height: ScreenUtil.getHeight(context) * 0.1,
                            child: InkWell(
                              onTap: _navigateToHomepage,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenPadding.padding15px,
                                  vertical: ScreenPadding.padding5px,
                                ),
                                decoration: ShapeDecoration(
                                  color: DertColor.chart.purple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      SizeRadius.radius20px,
                                    ),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: AutoSizeText(
                                    DertText.onboardButtonText,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : MaterialButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            },
                            color: DertColor.button.purple,
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.arrow_forward_sharp,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
