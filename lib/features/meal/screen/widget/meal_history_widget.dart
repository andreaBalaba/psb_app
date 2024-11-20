import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/meal/controller/meal_controller.dart';
import 'package:psb_app/features/meal/screen/meal_page.dart';
import 'package:psb_app/model/exercise_model.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class MealHistoryList extends StatefulWidget {
  const MealHistoryList({super.key});

  @override
  State<MealHistoryList> createState() => _MealHistoryListState();
}

class _MealHistoryListState extends State<MealHistoryList> {
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
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Foods').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(child: Text('Error'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                );
              }

              final data = snapshot.requireData;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  final meal = data.docs[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4 * autoScale),
                    child: MealHistoryCard(
                      meal: meal,
                    ),
                  );
                },
              );
            }),
      ],
    );
  }
}

class MealHistoryCard extends StatefulWidget {
  final dynamic meal;

  const MealHistoryCard({
    super.key,
    required this.meal,
  });

  @override
  State<MealHistoryCard> createState() => _MealHistoryCardState();
}

class _MealHistoryCardState extends State<MealHistoryCard> {
  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected != widget.meal.id) {
            selected = widget.meal.id;
          } else {
            selected = '';
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(10 * autoScale),
        decoration: BoxDecoration(
          color: selected == widget.meal.id
              ? AppColors.pGreen38Color
              : AppColors.pNoColor,
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
                  image: NetworkImage(widget.meal['img']),
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
                    text: widget.meal['name'],
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
                        label: widget.meal['calories'].toString(),
                        color: AppColors.pDarkOrangeColor,
                      ),
                      SizedBox(width: 8 * autoScale),
                      _buildInfoChip(
                        iconData: Icons.scale,
                        label: widget.meal['servingSize'].toString(),
                        color: AppColors.pGreyColor,
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
