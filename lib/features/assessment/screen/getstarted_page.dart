import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/screen/what_motivate_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  double autoScale = Get.width / 400; // Responsive scaling based on screen width

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    // Adjusted padding and button height

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0 * autoScale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),

                // Logo Section
                SizedBox(
                  width: screenWidth * 0.85,
                  height: screenWidth * 0.63, // Maintains aspect ratio
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.asset(
                      ImageAssets.pGetStartedPic, // Replace with your specific image asset path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Title Section
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 32 * autoScale,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                      letterSpacing: 1,
                    ),
                    children: [
                      TextSpan(text: "Assess ", style: TextStyle(color: AppColors.pSOrangeColor)),
                      TextSpan(text: "it First!", style: TextStyle(color: AppColors.pBlackColor)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.0 * autoScale), // Adjust spacing between elements

                // Description Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0 * autoScale),
                  child: ReusableText(
                    text:
                    "Before diving into the app's features, take a moment to assess your needs and goals. Ready to get started? Let's begin by reflecting on where you're at!",
                    size: 18 * autoScale,
                    fontWeight: FontWeight.w300,
                    align: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0 * autoScale),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.0 * autoScale, right: 20.0 * autoScale, top: 20.0 * autoScale, bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: ReusableButton(
            text: "Get Started",
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('seenIntro', true);
              // Navigation (uncomment if needed)
              Get.offAll(() => const MotivationPage(), transition: Transition.noTransition);
            },
            color: AppColors.pGreenColor,
            fontColor: AppColors.pWhiteColor,
            borderRadius: 0,
            size: 18 * autoScale,
            weight: FontWeight.w600,
            removePadding: true, // Set this to remove internal padding and fixed height
          ),
        ),
      ),
    );
  }
}
