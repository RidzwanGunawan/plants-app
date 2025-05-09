import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plants_app/constants/constants.dart';
import 'package:plants_app/ui/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animasi logo scale in
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Navigasi ke Onboarding setelah 2.5 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Plants App',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
