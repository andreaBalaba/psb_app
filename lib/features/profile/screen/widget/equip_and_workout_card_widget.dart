import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class UserCards extends StatelessWidget {
  const UserCards({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final autoScale = screenWidth / 400;
    final cardHeight = 108 * autoScale;

    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16 * autoScale),
            ),
            color: AppColors.pOrangeColor,
            elevation: 3,
            child: Container(
              height: cardHeight,
              padding: EdgeInsets.all(12 * autoScale),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReusableText(
                    text: "10",
                    size: 30 * autoScale,
                    fontWeight: FontWeight.bold,
                  ),
                  ReusableText(
                    text: "Equipment Captured",
                    size: 14 * autoScale,
                    fontWeight: FontWeight.w500,
                    color: AppColors.pBlack87Color,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10 * autoScale),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16 * autoScale),
            ),
            color: AppColors.pLightGreenColor,
            elevation: 3,
            child: Container(
              height: cardHeight, // Fixed height for all cards
              padding: EdgeInsets.all(12 * autoScale),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center-align content
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReusableText(
                    text: "3",
                    size: 30 * autoScale,
                    fontWeight: FontWeight.bold,
                  ),
                  ReusableText(
                    text: "Workout Plans",
                    size: 14 * autoScale,
                    fontWeight: FontWeight.w500,
                    color: AppColors.pBlack87Color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
