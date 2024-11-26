import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/screen/identify_sex_page.dart';
import 'package:psb_app/features/home/screen/home_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeelGoodPage extends StatefulWidget {
  const FeelGoodPage({super.key});

  @override
  State<FeelGoodPage> createState() => _FeelGoodPageState();
}

class _FeelGoodPageState extends State<FeelGoodPage> {
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
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Distribute items evenly across the row
          children: [
            // Left content (Leading)
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded,
                      size: 28 * autoScale, color: AppColors.pBlackColor),
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
                    width: screenWidth *
                        0.4, // Adjusted width for progress bar to center
                    child: LinearProgressIndicator(
                      value: 0.3,
                      minHeight:
                          9.0 * autoScale, // Dynamic height for progress bar
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
                    Get.offAll(() => const HomePage(),
                        transition: Transition.noTransition);
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
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Flexible(
                          flex: 5,
                          child: SizedBox(
                            width: constraints.maxWidth * 0.9,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Image.asset(
                                ImageAssets
                                    .pFeelGoodPic, // Replace with your specific image asset path
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 32 * autoScale,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                            children: const [
                              TextSpan(
                                  text: "Feel good ",
                                  style: TextStyle(
                                      color: AppColors.pSOrangeColor)),
                              TextSpan(
                                  text: "on your ",
                                  style:
                                      TextStyle(color: AppColors.pBlackColor)),
                              TextSpan(
                                  text: "big day!",
                                  style: TextStyle(
                                      color: AppColors.pSOrangeColor)),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40.0),
                        ReusableText(
                          text:
                              "Feeling great on your big day is all about preparation and self-care. "
                              "Prioritize rest, hydration, and positive energy to ensure you’re at your best.",
                          size: 18 * autoScale,
                          fontWeight: FontWeight.w300,
                          align: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20.0 * autoScale,
            right: 20.0 * autoScale,
            top: 20.0 * autoScale,
            bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: ReusableButton(
            text: "Next",
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('seenIntro', true);

              Get.to(() => const IdentifySexPage(),
                  transition: Transition.noTransition);
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
