import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class MealCardWidget extends StatefulWidget {
  const MealCardWidget({super.key});

  @override
  State<MealCardWidget> createState() => _MealCardWidgetState();
}

class _MealCardWidgetState extends State<MealCardWidget> {
  final PageController _pageController = PageController();
  double autoScale = Get.width / 360;

  @override
  Widget build(BuildContext context) {
    double cardHeight = 200.0 * autoScale;

    return Column(
      children: [
        SizedBox(
          height: cardHeight,
          child: PageView(
            controller: _pageController,
            children: [
              _buildCaloriesCard(),
              _buildMacrosCard(),
              _buildNutritionCard(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: const ScrollingDotsEffect(
            dotWidth: 6,
            dotHeight: 6,
            activeDotColor: AppColors.pBlackColor,
            dotColor: AppColors.pMGreyColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesCard() {
    return Card(
      color: AppColors.pOrangeColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0 * autoScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText(
              text: "Calories",
              size: 22 * autoScale,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: CircularPercentIndicator(
                      radius: 55.0 * autoScale,
                      lineWidth: 7 * autoScale,
                      percent: 0.3,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ReusableText(
                            text: "1700",
                            size: 30 * autoScale,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pWhiteColor,
                            shadows: const [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black26,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          ReusableText(
                            text: "Remaining",
                            size: 12 * autoScale,
                            color: AppColors.pWhiteColor,
                          ),
                        ],
                      ),
                      progressColor: AppColors.pGreenColor,
                      backgroundColor: AppColors.pMGreyColor,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            IconAssets.pGoalIcon,
                            width: 40 * autoScale,
                            height: 40 * autoScale,
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                text: "Base goal",
                                size: 16 * autoScale,
                                fontWeight: FontWeight.bold,
                              ),
                              ReusableText(
                                text: "1,680",
                                size: 14 * autoScale,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            IconAssets.pRiceBowlIcon,
                            width: 40 * autoScale,
                            height: 40 * autoScale,
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableText(
                                text: "Calories",
                                size: 16 * autoScale,
                                fontWeight: FontWeight.bold,
                              ),
                              ReusableText(
                                text: "300",
                                size: 14 * autoScale,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildMacrosCard() {
    return Card(
      color: AppColors.pOrangeColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0 * autoScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: "Macros",
              size: 22 * autoScale,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 25),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildMacroIndicator(
                        "Carbs", AppColors.pBlueColor, 0.6),
                  ),
                  SizedBox(width: 10 * autoScale),
                  Expanded(
                    child: _buildMacroIndicator(
                        "Fats", AppColors.pVioletColor, 0.4),
                  ),
                  SizedBox(width: 10 * autoScale),
                  Expanded(
                    child: _buildMacroIndicator(
                        "Protein", AppColors.pYellow, 0.8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroIndicator(String label, Color color, double percent) {
    double radius = (Get.width / 8.5) * autoScale;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0 * autoScale),
      child: CircularPercentIndicator(
        radius: radius,
        lineWidth: 6.0 * autoScale,
        percent: percent,
        center: ReusableText(
          text: label,
          size: 12 * autoScale,
          fontWeight: FontWeight.bold,
          color: AppColors.pWhiteColor,
          shadows: const [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black26,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        progressColor: color,
        backgroundColor: AppColors.pMGreyColor,
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }


  Widget _buildNutritionCard() {
    return Card(
      color: AppColors.pOrangeColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0 * autoScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: "Nutrition",
              size: 22 * autoScale,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 8 * autoScale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Fat",
                            size: 14 * autoScale,
                          ),
                          SizedBox(height: 3 * autoScale),
                          SizedBox(
                            height: 10 * autoScale,
                            width: 120 * autoScale,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: AppColors.pMGreyColor,
                              color: AppColors.pGreenColor,
                              minHeight: 8 * autoScale,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5 * autoScale),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Sodium",
                            size: 14 * autoScale,
                          ),
                          SizedBox(height: 3 * autoScale),
                          SizedBox(
                            height: 10 * autoScale,
                            width: 120 * autoScale,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: AppColors.pMGreyColor,
                              color: AppColors.pGreenColor,
                              minHeight: 8 * autoScale,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5 * autoScale),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Cholesterol",
                            size: 14 * autoScale,
                          ),
                          SizedBox(height: 3 * autoScale),
                          SizedBox(
                            height: 10 * autoScale,
                            width: 120 * autoScale,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: AppColors.pMGreyColor,
                              color: AppColors.pGreenColor,
                              minHeight: 8 * autoScale,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12 * autoScale),
                Expanded(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Sugar",
                            size: 14 * autoScale,
                          ),
                          SizedBox(height: 3 * autoScale),
                          SizedBox(
                            height: 10 * autoScale,
                            width: 120 * autoScale,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: AppColors.pMGreyColor,
                              color: AppColors.pGreenColor,
                              minHeight: 8 * autoScale,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5 * autoScale),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Fiber",
                            size: 14 * autoScale,
                          ),
                          SizedBox(height: 3 * autoScale),
                          SizedBox(
                            height: 10 * autoScale,
                            width: 120 * autoScale,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: AppColors.pMGreyColor,
                              color: AppColors.pGreenColor,
                              minHeight: 8 * autoScale,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5 * autoScale),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: "Carbohydrates",
                            size: 14 * autoScale,
                          ),
                          SizedBox(height: 3 * autoScale),
                          SizedBox(
                            height: 10 * autoScale,
                            width: 120 * autoScale,
                            child: LinearProgressIndicator(
                              value: 0.5,
                              backgroundColor: AppColors.pMGreyColor,
                              color: AppColors.pGreenColor,
                              minHeight: 8 * autoScale,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
