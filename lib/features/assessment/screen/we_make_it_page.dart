import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/screen/what_body_shape_page.dart';
import 'package:psb_app/features/home/screen/home_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeMakeItPage extends StatefulWidget {
  const WeMakeItPage({super.key});

  @override
  State<WeMakeItPage> createState() => _WeMakeItPageState();
}

class _WeMakeItPageState extends State<WeMakeItPage> {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, size: 28 * autoScale, color: AppColors.pBlackColor),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableText(
                    text: "Body data",
                    size: 20 * autoScale,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: LinearProgressIndicator(
                      value: 0.55,
                      minHeight: 9.0 * autoScale,
                      color: AppColors.pGreenColor,
                      backgroundColor: AppColors.pMGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.offAll(() => HomePage(), transition: Transition.noTransition);
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available height for the image and text content
          double availableHeight = constraints.maxHeight - screenHeight * 0.1;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * autoScale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                          TextSpan(text: "We will ", style: TextStyle(color: AppColors.pBlackColor)),
                          TextSpan(text: "make ", style: TextStyle(color: AppColors.pSOrangeColor)),
                          TextSpan(text: "it !", style: TextStyle(color: AppColors.pBlackColor)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    ReusableText(
                      text: "Consistency turns average into excellence, with planning as its foundation",
                      align: TextAlign.center,
                      size: 18 * autoScale,
                      fontWeight: FontWeight.w300,
                    ),
                  ],
                ),
                // Responsive image section
                SizedBox(
                  height: availableHeight * 0.87, // Adjust image height based on available space
                  child: Image.asset(
                    ImageAssets.pCalendarPic,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.0 * autoScale, right: 20.0 * autoScale, bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: ReusableButton(
            text: "Next",
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('seenIntro', true);
              Get.to(() => const BodyShapePage(), transition: Transition.noTransition);
            },
            color: AppColors.pGreenColor,
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
