import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/controller/assessment_controller.dart';
import 'package:psb_app/features/assessment/screen/we_make_it_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TargetWeightPage extends StatefulWidget {
  const TargetWeightPage({super.key});

  @override
  State<TargetWeightPage> createState() => _TargetWeightPageState();
}

class _TargetWeightPageState extends State<TargetWeightPage> {
  final AssessmentController controller = Get.put(AssessmentController());
  late PageController _pageController;
  final double autoScale = Get.width / 400;
  final int minWeight = 30;

  @override
  void initState() {
    super.initState();
    int initialWeight = int.tryParse(controller.weightController.text) ?? 70;
    _pageController = PageController(
      viewportFraction: 0.25,
      initialPage: initialWeight - minWeight,
    );
    controller.targetWeight.value = initialWeight;
    controller.calculateWeightChangeFeedback();

    _pageController.addListener(() {
      int middleIndex = _pageController.page!.round();
      setState(() {
        controller.targetWeight.value = middleIndex + minWeight;
      });
      controller.calculateWeightChangeFeedback();
    });
  }

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
            IconButton(
              icon: Icon(Icons.arrow_back_rounded, size: 28 * autoScale, color: AppColors.pBlackColor),
              onPressed: () {
                Get.back();
              },
            ),
            Column(
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
                    value: 0.5,
                    minHeight: 9.0 * autoScale,
                    color: AppColors.pGreenColor,
                    backgroundColor: AppColors.pMGreyColor,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Skip logic, potentially navigate to home
              },
              child: ReusableText(
                text: "Skip",
                color: AppColors.pGreenColor,
                fontWeight: FontWeight.w500,
                size: 14 * autoScale,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: screenWidth * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28 * autoScale,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                children: const [
                  TextSpan(text: "What is your ", style: TextStyle(color: AppColors.pBlackColor)),
                  TextSpan(text: "target ", style: TextStyle(color: AppColors.pSOrangeColor)),
                  TextSpan(text: "weight?", style: TextStyle(color: AppColors.pBlackColor)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20 * autoScale),
                child: Center(
                  child: ListView(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.5,
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset(
                            ImageAssets.pTargetWeightPic,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15), // Reduced spacing
                      SizedBox(
                        height: 80, // Reduced height
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: 151,
                              itemBuilder: (context, index) {
                                final weight = index + minWeight;
                                return Center(
                                  child: ReusableText(
                                    text: "$weight",
                                    size: weight == controller.targetWeight.value ? 30 * autoScale : 20 * autoScale, // Reduced text size
                                    color: weight == controller.targetWeight.value ? AppColors.pBlackColor : AppColors.pGreyColor,
                                    fontWeight: weight == controller.targetWeight.value ? FontWeight.bold : FontWeight.normal,
                                  ),
                                );
                              },
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 60, // Reduced height
                                    width: 4, // Reduced width
                                    decoration: BoxDecoration(
                                      color: AppColors.pSOrangeColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  const SizedBox(width: 60), // Reduced spacing
                                  Container(
                                    height: 60, // Reduced height
                                    width: 4, // Reduced width
                                    decoration: BoxDecoration(
                                      color: AppColors.pSOrangeColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: ReusableText(
                          text: "Kg",
                          size: 16 * autoScale, // Reduced font size
                          color: AppColors.pBlackColor,
                        ),
                      ),
                      const SizedBox(height: 15), // Reduced spacing
                      Obx(() => Container(
                        width: screenWidth * 0.75, // Adjusted width
                        padding: const EdgeInsets.all(12), // Reduced padding
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10), // Reduced border radius
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: controller.weightChangeHeader.value,
                              size: 18 * autoScale, // Reduced font size
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 5),
                            ReusableText(
                              text: controller.weightChangeSemiHeader.value,
                              size: 14 * autoScale, // Reduced font size
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 5),
                            ReusableText(
                              text: controller.weightChangeMessage.value,
                              size: 14 * autoScale, // Reduced font size
                              color: AppColors.pDarkGreyColor,
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.0 * autoScale, right: 20.0 * autoScale, top: 10.0 * autoScale, bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          child: ReusableButton(
            text: "Next",
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('seenIntro', true);
              Get.to(() => const WeMakeItPage(), transition: Transition.noTransition);
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
