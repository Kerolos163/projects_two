import 'dart:async';
import 'package:flutter/material.dart';
import '../Auth/views/login_screen.dart';
import '../onboarding/presentation/views/onboarding_screen.dart';
import '../user/layout/view/layout_screen.dart';
import '../../../Core/utils/app_constants.dart';
import '../../../Core/Services/preferences_manager.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
        );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoController.forward();
    Future.delayed(
      const Duration(milliseconds: 800),
      () => _textController.forward(),
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      final Widget next = _getStartScreen();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => next));
    });
  }

  Widget _getStartScreen() {
    final bool? isFirstTime = PreferencesManager.getBool(
      AppConstants.firstTime,
    );
    if (isFirstTime == null) return const OnboardingScreen();

    final String? token = PreferencesManager.getString(
      AppConstants.userTokenKey,
    );
    if (token == null) return const LoginScreen();

    final String? userInfo = PreferencesManager.getString(
      AppConstants.userInfo,
    );
    if (userInfo == null) return const LoginScreen();

    return const LayoutScreen();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/image/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: const Text(
                "Made with love, just like home",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
