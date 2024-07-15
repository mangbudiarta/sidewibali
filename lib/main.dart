import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidewibali/views/onboarding_page.dart';
import 'package:sidewibali/views/home_page.dart';
import 'package:sidewibali/views/registrasi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sidewi Bali',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/homepage': (context) => const HomePage(),
        '/registration': (context) => const RegisterView(),
        '/onboarding': (context) => const OnboardingView(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    _initApp();
  }

  void _initApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingShown = prefs.getBool('onboardingShown') ?? false;
    await Future.delayed(const Duration(seconds: 2));

    if (onboardingShown) {
      // Navigator.of(context).pushReplacementNamed('/homepage');
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushReplacementNamed('/onboarding');
          prefs.setBool('onboardingShown', true);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_kotak.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to Sidewi Bali',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
