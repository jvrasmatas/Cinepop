import 'dart:async';

import 'package:flutter/material.dart';

import '../config/app_router.dart';
import '../config/constants.dart';
import '../themes/colors.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Wait 2 seconds, then move on to the home screen.
    _timer = Timer(const Duration(seconds: 2), _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRouter.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(fontSize: 44),
              const SizedBox(height: 16),
              Text(
                'Descubre tu próxima película',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.popRed,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'v${AppConstants.appVersion}',
                style: const TextStyle(color: AppColors.divider, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
