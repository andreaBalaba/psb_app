import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class EquipmentDetailsPage extends StatelessWidget {
  final String imagePath;
  final String name;
  final String level;
  final String duration;
  final String calories;
  final String description;

  const EquipmentDetailsPage({
    super.key,
    required this.imagePath,
    required this.name,
    required this.level,
    required this.duration,
    required this.calories,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        surfaceTintColor: AppColors.pNoColor,
        elevation: 0.5,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 16.0 * autoScale, left: 16.0 * autoScale, right: 16.0 * autoScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ReusableText(
                    text: name,
                    fontWeight: FontWeight.bold,
                    size: 22 * autoScale,
                  ),
                  SizedBox(height: 4 * autoScale),
                  ReusableText(
                    text: level,
                    fontWeight: FontWeight.w500,
                    size: 14 * autoScale,
                    color: AppColors.pGreyColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20 * autoScale),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0 * autoScale),
                  color: AppColors.pBlack87Color,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0 * autoScale),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 200 * autoScale,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16 * autoScale),

            // Custom Info Chip Row
            Center(
              child: Container(
                padding: EdgeInsets.all(12.0 * autoScale),
                decoration: BoxDecoration(
                  color: AppColors.pBlack12Color,
                  borderRadius: BorderRadius.circular(12.0 * autoScale),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Duration Info with Image Icon
                    Row(
                      children: [
                        Image.asset(
                          IconAssets.pClockIcon,
                          color: AppColors.pDarkGreenColor,
                          height: 18 * autoScale,
                          width: 18 * autoScale,
                        ),
                        SizedBox(width: 4.0 * autoScale),
                        ReusableText(
                          text: duration,
                          size: 14.0 * autoScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pDarkGreenColor,
                        ),
                      ],
                    ),
                    SizedBox(width: 12 * autoScale),
                    Container(
                      height: 20 * autoScale,
                      width: 1.0,
                      color: AppColors.pBlackColor,
                    ),
                    SizedBox(width: 12 * autoScale),

                    // Calories Info with Image Icon
                    Row(
                      children: [
                        Image.asset(
                          IconAssets.pFireIcon,
                          color: AppColors.pDarkOrangeColor,
                          height: 18 * autoScale,
                          width: 18 * autoScale,
                        ),
                        SizedBox(width: 4.0 * autoScale),
                        ReusableText(
                          text: "$calories kcal",
                          size: 14.0 * autoScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pDarkOrangeColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20 * autoScale),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableText(
                  text: "Proper usage",
                  fontWeight: FontWeight.bold,
                  size: 20 * autoScale,
                ),
                SizedBox(width: 8 * autoScale),
                Icon(
                  Icons.volume_up,
                  size: 20 * autoScale,
                  color: AppColors.pBlackColor,
                ),
              ],
            ),
            SizedBox(height: 10 * autoScale),

            Expanded(
              child: SingleChildScrollView(
                child: ReusableText(
                  text: description,
                  size: 14 * autoScale,
                  align: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
