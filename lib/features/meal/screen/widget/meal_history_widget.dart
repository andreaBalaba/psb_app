import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/meal/controller/meal_controller.dart';
import 'package:psb_app/model/exercise_model.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class MealHistoryList extends StatelessWidget {
  const MealHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;
    final MealController controller = Get.put(MealController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Meal History" Header
        Padding(
          padding: EdgeInsets.only(left: 5.0 * autoScale),
          child: ReusableText(
            text: "History",
            size: 24 * autoScale,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Meal History List
        Obx(() {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.mealHistoryList.length,
            itemBuilder: (context, index) {
              final meal = controller.mealHistoryList[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4 * autoScale),
                child: MealHistoryCard(
                  meal: meal,
                  onTap: () {
                    controller.addMeal(meal); // Trigger meal addition
                  },
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

class MealHistoryCard extends StatelessWidget {
  final MealHistory meal;
  final VoidCallback onTap;

  const MealHistoryCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return GestureDetector(
      onTap: (){

      },
      child: Container(
        padding: EdgeInsets.all(10 * autoScale),
        decoration: BoxDecoration(
          color: meal.isAdded ? AppColors.pGreen38Color : AppColors.pNoColor,
          borderRadius: BorderRadius.circular(12 * autoScale),
        ),
        child: Row(
          children: [
            // Meal Image
            Container(
              width: 60.0 * autoScale,
              height: 60.0 * autoScale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8 * autoScale),
                image: DecorationImage(
                  image: AssetImage(meal.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12 * autoScale),

            // Meal Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Title
                  ReusableText(
                    text: meal.title,
                    fontWeight: FontWeight.w600,
                    size: 18 * autoScale,
                    color: AppColors.pBlack87Color,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  // Meal Info Chips
                  Row(
                    children: [
                      _buildInfoChip(
                        iconPath: IconAssets.pFireIcon,
                        label: meal.calories,
                        color: AppColors.pDarkOrangeColor,
                      ),
                      SizedBox(width: 8 * autoScale),
                      _buildInfoChip(
                        iconData: Icons.scale,
                        label: meal.weight,
                        color: AppColors.pGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add Button Icon
            GestureDetector(
              onTap: (){

              },
              child: Container(
                padding: EdgeInsets.all(6.0 * autoScale),
                decoration: BoxDecoration(
                  color: AppColors.pWhiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: 20.0 * autoScale,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method for Info Chips
  Widget _buildInfoChip({
    String? iconPath,
    IconData? iconData,
    required String label,
    required Color color,
  }) {
    double autoScale = Get.width / 360;

    return Container(
      padding: EdgeInsets.all(3.0 * autoScale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * autoScale),
      ),
      child: Row(
        children: [
          if (iconPath != null)
            Image.asset(
              iconPath,
              height: 12.0 * autoScale,
              width: 12.0 * autoScale,
              color: color,
            )
          else if (iconData != null)
            Icon(
              iconData,
              size: 12.0 * autoScale,
              color: color,
            ),
          SizedBox(width: 4.0 * autoScale),
          ReusableText(
            text: label,
            size: 11.0 * autoScale,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ],
      ),
    );
  }
}
