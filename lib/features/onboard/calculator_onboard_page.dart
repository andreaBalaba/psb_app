import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/onboard/widget/calculator_first_page.dart';
import 'package:psb_app/features/onboard/widget/calculator_fourth_page.dart';
import 'package:psb_app/features/onboard/widget/calculator_second_page.dart';
import 'package:psb_app/features/onboard/widget/calculator_third_page.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardCalculator extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardCalculator({super.key, required this.onComplete});

  @override
  State<OnboardCalculator> createState() => _OnboardCalculatorState();
}

class _OnboardCalculatorState extends State<OnboardCalculator> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 400;

    return Scaffold(
      backgroundColor: AppColors.pPurpleColor,
      appBar: AppBar(
        backgroundColor: AppColors.pNoColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.pWhite54Color,
        ),
        actions: [
          if (_currentPage < 3) // Show Skip button if not on the last page
            TextButton(
              onPressed: widget.onComplete,
              child: ReusableText(
                text: 'Skip',
                color: AppColors.pWhite54Color,
                size: 16 * autoScale, // Responsive font size
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      body: Stack( // Use Stack to overlay the indicator
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              FirstOnboardPage(autoScale: autoScale),
              SecondOnboardPage(autoScale: autoScale),
              ThirdOnboardPage(autoScale: autoScale),
              FourthOnboardPage(
                autoScale: autoScale,
                onComplete: widget.onComplete // Call the onComplete callback to navigate,
              ),
            ],
          ),
          // Smooth Page Indicator
          Align(
            alignment: Alignment.bottomCenter, // Position the indicator at the bottom
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0), // Adjust padding to overlap
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 4, // Number of pages
                effect: ScrollingDotsEffect(
                  activeDotColor: AppColors.pLightPurpleColor,
                  dotColor: AppColors.pLightPurpleColor,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
                onDotClicked: (index) => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
