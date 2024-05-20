import 'package:flutter/material.dart';
import 'package:sidewibali/utils/colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/images/onboarding_3.png'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                Text(
                  "Explore The Beautiful Places",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "nunitoBold", fontSize: 24, color: black),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  child: Text(
                    "Explore vilages in Bali by one click, so easy and helpfullExplore vilages in Bali by one click, so easy and helpfull",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "nunitoRegular",
                        fontSize: 14,
                        color: textW2),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => print("Lanjutkan"),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13.5),
                decoration: BoxDecoration(
                    color: primary, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  "Next",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "nunitoSemiBold", fontSize: 14, color: white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
