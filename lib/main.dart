import 'package:flutter/material.dart';
import 'package:sidewibali/views/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sidewi Bali',
      debugShowCheckedModeBanner: false,
      home: const OnboardingView(),
    );
  }
}
