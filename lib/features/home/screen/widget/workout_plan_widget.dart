import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/controller/home_controller.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class WorkoutPlanList extends StatelessWidget {
  const WorkoutPlanList({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    double autoScale = Get.width / 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0 * autoScale),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                text: "Hit it right",
                size: 24 * autoScale,
                fontWeight: FontWeight.bold,
              ),
              InkWell(
                onTap: () {

                },
                child: ReusableText(
                  text: "See all",
                  color: AppColors.pGreenColor,
                  fontWeight: FontWeight.w600,
                  size: 16 * autoScale,

                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6 * autoScale),
        SizedBox(
          height: 220 * autoScale,
          child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.0 * autoScale),
            itemCount: controller.workoutPlans.length > 3 ? 3 : controller.workoutPlans.length, // Limit to 3
            itemBuilder: (context, index) {
              final workout = controller.workoutPlans[index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 3.0 * autoScale : 0,  // Add left padding for the first item
                  right: index == 2 ? 0 * autoScale : 10.0,                  // Add right padding for all items
                ),
                child: _WorkoutPlanCard(
                  imagePath: workout.imagePath,
                  title: workout.title,
                  subtitle: workout.subtitle,
                  duration: workout.duration,
                  calories: workout.calories,
                ),
              );
            },
          )),
        ),
      ],
    );
  }
}

class _WorkoutPlanCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String duration;
  final String calories;

  const _WorkoutPlanCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return Padding(
      padding: EdgeInsets.only(
        top: 5 * autoScale,
        right: 10 * autoScale,
        bottom: 12 * autoScale, // Adding bottom margin here
      ),
      child: Container(
        width: Get.width * 0.75,
        decoration: BoxDecoration(
          color: AppColors.pWhiteColor,
          borderRadius: BorderRadius.circular(12 * autoScale),
          boxShadow: [
            BoxShadow(
              color: AppColors.pBlack12Color,
              offset: Offset(0, 2 * autoScale),
              blurRadius: 5 * autoScale,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12 * autoScale)),
              child: Image.asset(
                imagePath,
                height: 100 * autoScale,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 4 * autoScale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12 * autoScale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      size: 22 * autoScale,
                      color: AppColors.pBlackColor,
                      overflow: TextOverflow.ellipsis,
                  ),
                  ReusableText(
                      text: subtitle,
                      size: 14 * autoScale,
                      color: AppColors.pGreyColor,
                      overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6 * autoScale),
                  Row(
                    children: [
                      _buildInfoChip(
                        context,
                        iconPath: IconAssets.pClockIcon,
                        label: duration,
                        color: AppColors.pDarkGreenColor,
                        backgroundColor: AppColors.pGreen38Color,
                        borderColor: AppColors.pDarkGreenColor,
                      ),
                      SizedBox(width: 10 * autoScale),
                      _buildInfoChip(
                        context,
                        iconPath: IconAssets.pFireIcon,
                        label: calories,
                        color: AppColors.pDarkOrangeColor,
                        backgroundColor: AppColors.pLightOrangeColor,
                        borderColor: AppColors.pDarkOrangeColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context, {
        required String iconPath,
        required String label,
        required Color color,
        required Color backgroundColor,
        required Color borderColor,
      }) {
    double autoScale = Get.width / 360;

    return Container(
      padding: EdgeInsets.all( 3.0 * autoScale), // Reduced padding for smaller chip
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0 * autoScale), // Smaller radius
        border: Border.all(color: borderColor, width: 1.0 * autoScale),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 12.0 * autoScale, // Reduced icon size
            width: 12.0 * autoScale,
            color: color,
          ),
          SizedBox(width: 4.0 * autoScale),
          ReusableText(
              text: label,
              size: 11.0 * autoScale, // Increased text size
              fontWeight: FontWeight.w500,
              color: color,
            ),
        ],
      ),
    );
  }
}
