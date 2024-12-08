import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class WeeklyProgressCard extends StatelessWidget {
  WeeklyProgressCard({super.key});

  final autoScale = Get.width / 400;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.pOrangeColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16.0 * autoScale),
        constraints: BoxConstraints(
          minHeight: 150 * autoScale,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: CircularPercentIndicator(
                      radius: 50.0 * autoScale,
                      lineWidth: 7.5 * autoScale,
                      percent: 0.3,
                      center: ReusableText(
                        text: "25%",
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
                      progressColor: AppColors.pGreenColor,
                      backgroundColor: AppColors.pMGreyColor,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                ),
                SizedBox(width: 10 * autoScale),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: "Weekly Progress",
                        size: 18 * autoScale,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 15 * autoScale),
                      _buildProgressRow("Total workouts:", "20"),
                      _buildProgressRow("Calories burned:", "3000 kcal"),
                      _buildProgressRow("Total distance:", "1,000 km"),
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

  Widget _buildProgressRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReusableText(
          text: title,
          fontWeight: FontWeight.w500,
          size: 15 * autoScale,
        ),
        ReusableText(
          text: value,
          size: 15 * autoScale,
        ),
      ],
    );
  }
}
