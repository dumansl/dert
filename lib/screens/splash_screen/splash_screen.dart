import 'dart:async';
import 'dart:math';
import 'package:dert/screens/screens.dart';
import 'package:dert/services/connectivity_services.dart';
import 'package:dert/services/shared_preferences_service.dart';
import 'package:dert/utils/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late SharedPreferencesService _sharedPreferencesService;
  late String mobileGifPath;
  late String desktopGifPath;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _sharedPreferencesService = SharedPreferencesService();

    mobileGifPath = getRandomGifPath('mobile');
    desktopGifPath = getRandomGifPath('desktop');

    Future.delayed(const Duration(seconds: 3), () {
      _checkConnectivityAndNavigate();
    });
  }

  _checkConnectivityAndNavigate() async {
    final connectivityProvider = context.read<ConnectivityService>();
    await connectivityProvider.checkInternetConnection();
    if (connectivityProvider.isOnline) {
      _navigateToNextScreen();
    } else {
      if (mounted) {
        _showConnectionWarning(context);
      }
    }
  }

  _navigateToNextScreen() async {
    if (_sharedPreferencesService.isFirstTime()) {
      await _sharedPreferencesService.setFirstTime(false);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    } else if (_sharedPreferencesService.isLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  String getRandomGifPath(String platform) {
    final Random random = Random();
    final int randomNumber = random.nextInt(2) + 1;

    return 'assets/gifs/${platform}_$randomNumber.gif';
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityService>().isOnline;

    return Scaffold(
      body: isOnline
          ? Image.asset(
              ResponsiveBuilder.isDesktop(context)
                  ? desktopGifPath
                  : mobileGifPath,
              fit: BoxFit.cover,
              width: ScreenUtil.getWidth(context),
              height: ScreenUtil.getHeight(context),
            )
          : Container(),
    );
  }

  _showConnectionWarning(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('İnternet Bağlantısı Yok'),
          content: const Text(
              'Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final connectivityProvider =
                    Provider.of<ConnectivityService>(context, listen: false);
                await connectivityProvider.checkInternetConnection();
                if (connectivityProvider.isOnline) {
                  Navigator.pop(context);
                  _navigateToNextScreen();
                }
              },
              child: const Text('Tekrar Dene'),
            ),
          ],
        );
      },
    );
  }
}
