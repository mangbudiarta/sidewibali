import 'package:flutter/material.dart';
import 'package:sidewibali/utils/colors.dart';

List onboardingData = [
  {
    "image": "assets/images/onboarding_1.png",
    "title": "Explore The Beautiful Places",
    "desc":
        "Explore vilages in Bali by one click, so easy and helpfullExplore vilages in Bali by one click, so easy and helpfull"
  },
  {
    "image": "assets/images/onboarding_2.png",
    "title": "Enjoy Beautiful Village Scenery",
    "desc":
        "elight in the picturesque charm of village landscapes, where nature's beauty and serene surroundings offer a peaceful escape"
  },
  {
    "image": "assets/images/onboarding_3.png",
    "title": "Start with Sidewi Bali",
    "desc":
        "Discover stunning destinations and hidden gems at your fingertips. Start your adventure today with our easy-to-use app"
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
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Image.asset(onboardingData[i]['image']),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Column(
                          children: [
                            Text(
                              onboardingData[i]['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "nunitoBold",
                                  fontSize: 24,
                                  color: black),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 20, 16, 20),
                              child: Text(
                                onboardingData[i]['desc'],
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
                    ],
                  );
                }),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  spacing: 6,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                          color: currentPage == 0 ? primary : textW2,
                          borderRadius: BorderRadius.circular(4)),
                      height: 8,
                      width: currentPage == 0 ? 20 : 8,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                          color: currentPage == 1 ? primary : textW2,
                          borderRadius: BorderRadius.circular(4)),
                      height: 8,
                      width: currentPage == 1 ? 20 : 8,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                          color: currentPage == 2 ? primary : textW2,
                          borderRadius: BorderRadius.circular(4)),
                      height: 8,
                      width: currentPage == 2 ? 20 : 8,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    pageController.animateToPage(currentPage + 1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                        color: primary, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      currentPage == 2 ? "Start Now" : "Next",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "nunitoSemiBold",
                          fontSize: 14,
                          color: white),
                    ),
                  ),
                ),
              ),
              currentPage == 2
                  ? const SizedBox(
                      height: 47,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          pageController.animateToPage(2,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 13.5),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(4)),
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
            ],
          ),
        ],
      ),
    );
  }
}
