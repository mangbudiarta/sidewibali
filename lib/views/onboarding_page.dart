import 'package:flutter/material.dart';
import 'package:sidewibali/utils/colors.dart';

List onboardingData = [
  {
    "image": "assets/images/onboarding_1.png",
    "title": "Explore The Beautiful Places",
    "desc": "Explore villages in Bali by one click, so easy and helpful."
  },
  {
    "image": "assets/images/onboarding_2.png",
    "title": "Enjoy Beautiful Village Scenery",
    "desc":
        "Delight in the picturesque charm of village landscapes, where nature's beauty and serene surroundings offer a peaceful escape."
  },
  {
    "image": "assets/images/onboarding_31.png",
    "title": "Start with Sidewi Bali",
    "desc":
        "Discover stunning destinations and hidden gems at your fingertips. Start your adventure today with our easy-to-use app."
  }
];

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (v) {
                setState(() {
                  currentPage = v;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (_, i) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double imageHeight = constraints.maxHeight * 0.5;
                    return Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Image.asset(
                                  onboardingData[i]['image'],
                                  height: imageHeight,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      onboardingData[i]['title'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "nunitoBold",
                                          fontSize: 24,
                                          color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 20, 16, 20),
                                      child: Text(
                                        onboardingData[i]['desc'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "nunitoRegular",
                                            fontSize: 14,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  spacing: 6,
                  children: List.generate(onboardingData.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                          color: currentPage == index ? primary : Colors.grey,
                          borderRadius: BorderRadius.circular(4)),
                      height: 8,
                      width: currentPage == index ? 20 : 8,
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    if (currentPage == onboardingData.length - 1) {
                      Navigator.pushReplacementNamed(context, '/homepage');
                    } else {
                      pageController.animateToPage(currentPage + 1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      currentPage == onboardingData.length - 1
                          ? "Start Now"
                          : "Next",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "nunitoSemiBold",
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: currentPage == onboardingData.length - 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registration');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13.5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "nunitoSemiBold",
                            fontSize: 14,
                            color: primary),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: currentPage != onboardingData.length - 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      pageController.animateToPage(onboardingData.length - 1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13.5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Skip",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "nunitoSemiBold",
                            fontSize: 14,
                            color: primary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
