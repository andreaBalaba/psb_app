import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/controller/assessment_controller.dart';
import 'package:psb_app/features/assessment/screen/muscle_gain_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MainGoalPage extends StatefulWidget {
  const MainGoalPage({super.key});

  @override
  State<MainGoalPage> createState() => _MainGoalPageState();
}

class _MainGoalPageState extends State<MainGoalPage> {
  final AssessmentController controller = Get.put(AssessmentController());
  final List<String> choices = ["Lose weight", "Build muscle", "Keep fit"];
  final List<String> images = [
    ImageAssets.pLoseWeightPic,
    ImageAssets.pBuildMusclePic,
    ImageAssets.pKeepFitPic,
  ];

  double autoScale = Get.width / 400;

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;


    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.pBGWhiteColor,
        surfaceTintColor: AppColors.pNoColor,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute items evenly across the row
          children: [
            // Left content (Leading)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, size: 28 * autoScale, color: AppColors.pBlackColor),
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () {
                    Get.back();
                  },
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
                      value: 0.1,
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
                children: const [
                  TextSpan(text: "What is your main", style: TextStyle(color: AppColors.pBlackColor)),
                  TextSpan(text: " Goal", style: TextStyle(color: AppColors.pSOrangeColor)),
                  TextSpan(text: " ?", style: TextStyle(color: AppColors.pBlackColor)),
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
                      setState(() {
                        controller.selectedGoalIndex(index);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      decoration: BoxDecoration(
                        color: controller.selectedGoalIndex.value == index
                            ? AppColors.pGreen38Color // Highlight selected choice
                            : AppColors.pWhiteColor,
                        border: Border.all(
                          color: controller.selectedGoalIndex.value == index
                              ? AppColors.pGreenColor
                              : AppColors.pMGreyColor,
                        ),
                        borderRadius: BorderRadius.circular(12.0 * autoScale), // Responsive border radius
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.04),
                              child: ReusableText(
                                  text: choices[index],
                                  fontWeight: FontWeight.w600,
                                  size: 16 * autoScale, // Responsive font size for choices
                                ),
                              ),
                            ),
                          Container(
                            height: 130 * autoScale, // Dynamic height for images
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(10.0)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(10.0)),
                              child: Image.asset(
                                images[index],
                                width: screenWidth * 0.42,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
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
          child: ReusableButton(
            text: "Next",
            onPressed: controller.selectedGoalIndex.value == -1
                ? null
                : () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('seenIntro', true);

              Get.to(() => const MuscleGainPage(), transition: Transition.noTransition);


            },
            color: controller.selectedGoalIndex.value == -1 ? AppColors.pNoColor : AppColors.pGreenColor,
            fontColor: AppColors.pWhiteColor,
            borderRadius: 0,
            size: 18 * autoScale,
            weight: FontWeight.w600,
            removePadding: true,
          ),
        ),
      ),
    );
  }
}
