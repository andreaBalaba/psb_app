import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/screen/what_goal_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/assessment_controller.dart';

class MotivationPage extends StatefulWidget {
  const MotivationPage({super.key});

  @override
  State<MotivationPage> createState() => _MotivationPageState();
}

class _MotivationPageState extends State<MotivationPage> {
  final AssessmentController controller = Get.put(AssessmentController());
  final List<String> choices = ["Feel confident", "Release stress", "Improve health", "Boost energy", "Get shaped"];
  final List<String> icons = [
    IconAssets.pConfidentIcon,
    IconAssets.pReleaseStressIcon,
    IconAssets.pImproveHealthIcon,
    IconAssets.pEnergyIcon,
    IconAssets.pGetShapeIcon,
  ];

  double autoScale = Get.width / 400;

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        surfaceTintColor: AppColors.pNoColor,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute items evenly across the row
          children: [
            // Left content (Leading)
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0), // Add padding to prevent it from sticking to the edge
                  child: SizedBox(height: 20.0),
                ),
              ),
            ),

            // Center content (Goal text and progress bar)
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableText(
                    text: "Goal",
                      size: 20 * autoScale,
                      fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: screenWidth * 0.4, // Adjusted width for progress bar to center
                    child: LinearProgressIndicator(
                      value: 0.05,
                      minHeight: 9.0 * autoScale, // Dynamic height for progress bar
                      color: AppColors.pGreenColor,
                      backgroundColor: AppColors.pMGreyColor,
                    ),
                  ),
                ],
              ),
            ),

            // Right content (Skip button)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {

                  },
                  child: ReusableText(
                      text: "Skip",
                      color: AppColors.pGreenColor,
                      fontWeight: FontWeight.w500,
                      size: 14 * autoScale,
                    ),
                  ),
                ),
              ),
              ],
            ),
        ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: screenWidth * 0.01 ),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28 * autoScale,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                children: [
                  TextSpan(text: "What ", style: TextStyle(color: AppColors.pBlackColor)),
                  TextSpan(text: "motivates ", style: TextStyle(color: AppColors.pSOrangeColor)),
                  TextSpan(text: "you the most?", style: TextStyle(color: AppColors.pBlackColor)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: choices.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.selectedMotivationIndex(index); // Update selected choice in controller
                    },
                    child: Obx(
                          () => Container(
                        margin: EdgeInsets.symmetric(vertical: 14.0 * autoScale),
                        padding: EdgeInsets.all(10.0 * autoScale),
                        decoration: BoxDecoration(
                          color: controller.selectedMotivationIndex.value == index
                              ? AppColors.pGreen38Color
                              : AppColors.pWhiteColor,
                          border: Border.all(
                            color: controller.selectedMotivationIndex.value == index
                                ? AppColors.pGreenColor
                                : AppColors.pMGreyColor,
                          ),
                          borderRadius: BorderRadius.circular(12.0 * autoScale),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              icons[index],
                              width: 30 * autoScale,
                              height: 30 * autoScale,
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: ReusableText(
                                text: choices[index],
                                size: 16 * autoScale,
                                fontWeight: FontWeight.w600,
                                color: AppColors.pBlackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.0 * autoScale, right: 20.0 * autoScale, top: 20.0 * autoScale, bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: Obx(
                () => ReusableButton(
              text: "Next",
              onPressed: controller.selectedMotivationIndex.value == -1
                  ? null
                  : () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seenIntro', true);

                Get.to(() => MainGoalPage(), transition: Transition.noTransition);
              },
              color: controller.selectedMotivationIndex.value == -1
                  ? AppColors.pNoColor
                  : AppColors.pGreenColor,
              fontColor: AppColors.pWhiteColor,
              borderRadius: 0,
              size: 18 * autoScale,
              weight: FontWeight.w600,
              removePadding: true,
            ),
          ),
        ),
      ),
    );
  }
}
