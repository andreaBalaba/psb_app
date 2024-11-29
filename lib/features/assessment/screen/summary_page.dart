import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/screen/home_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:psb_app/utils/reusable_button.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double autoScale = Get.width / 400;
    final double screenHeight = Get.height;

    // Example workout plan list for a new user
    final List<String> workoutPlan = [
      'Week 1 : Wake up your body',
      'Week 2 : Burn Fat',
      'Week 3 : Build Strength',
      'Week 4 : Increase Endurance',
      'Week 5 : Toning',
      'Week 6 : Advanced Burn'
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pWhiteColor,
        elevation: 0,
        toolbarHeight: 30.0,
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColors.pNoColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0 * autoScale),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header message
              Center(
                child: ReusableText(
                  text: 'Based on your answers, you will be',
                  size: 18 * autoScale,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0 * autoScale),
              // Target weight and date
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32 * autoScale,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                    children: const [
                      TextSpan(text: "75 kg", style: TextStyle(color: AppColors.pSOrangeColor)),
                      TextSpan(text: " on ", style: TextStyle(color: AppColors.pBlackColor)),
                      TextSpan(text: "Dec 25", style: TextStyle(color: AppColors.pSOrangeColor)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.0 * autoScale),
              // Designed for you section
              ReusableText(
                text: 'Designed for you',
                size: 18 * autoScale,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10.0 * autoScale),
              Container(
                padding: EdgeInsets.all(16.0 * autoScale),
                decoration: BoxDecoration(
                  color:AppColors.pPitchColor,
                  borderRadius: BorderRadius.circular(12 * autoScale),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIconTextRow(
                      imagePath: IconAssets.pTargetIcon,
                      label: 'Focus Area',
                      value: 'Full body',
                      autoScale: autoScale,
                    ),
                    SizedBox(height: 10.0 * autoScale),
                    _buildIconTextRow(
                      imagePath: IconAssets.pDurationIcon,
                      label: 'Duration',
                      value: '10 - 30 mins',
                      autoScale: autoScale,
                    ),
                    SizedBox(height: 10.0 * autoScale),
                    _buildIconTextRow(
                      imagePath: IconAssets.pWaterIntakeIcon,
                      label: 'Water Intake',
                      value: '10 glass a day',
                      autoScale: autoScale,
                    ),
                    SizedBox(height: 10.0 * autoScale),
                    _buildIconTextRow(
                      imagePath: IconAssets.pBurnCaloriesIcon,
                      label: 'Daily burned calories',
                      value: '500 kcal',
                      autoScale: autoScale,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0 * autoScale),
              // Plan Preview
              ReusableText(
                text: 'Plan Preview',
                size: 18 * autoScale,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10.0 * autoScale),

              // Display each plan item in the list
              ...workoutPlan.map((item) => _buildPlanItem(item, autoScale)),

              // Add space at the bottom of the scroll view
              SizedBox(height: 20.0 * autoScale),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.0 * autoScale, right: 20.0 * autoScale, top: 20.0 * autoScale, bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: ReusableButton(
            text: "GET MY PLAN",
            onPressed: () {
              Get.offAll(() => const HomePage(), transition: Transition.noTransition);
            },
            color: AppColors.pGreenColor,
            fontColor: AppColors.pWhiteColor,
            borderRadius: 30.0 * autoScale,
            size: 18 * autoScale,
            weight: FontWeight.w600,
            removePadding: true,
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextRow({
    required String imagePath,
    required String label,
    required String value,
    required double autoScale,
  }) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 40 * autoScale,
          height: 40 * autoScale,
        ),
        SizedBox(width: 8.0 * autoScale),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: label,
              size: 14 * autoScale,
              fontWeight: FontWeight.w400,
              color: AppColors.pDarkGreyColor,
            ),
            ReusableText(
              text: value,
              size: 16 * autoScale,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanItem(String text, double autoScale) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0 * autoScale, bottom: 16.0 * autoScale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.circle, color: AppColors.pGreenColor, size: 8 * autoScale),
          SizedBox(width: 8.0 * autoScale),
          ReusableText(
            text: text,
            size: 16 * autoScale,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
