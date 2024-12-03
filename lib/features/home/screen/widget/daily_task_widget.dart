import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/controller/home_controller.dart';
import 'package:psb_app/features/home/screen/daily_task_page.dart';
import 'package:psb_app/model/exercise_model.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class DailyTaskList extends StatelessWidget {
  String id;
  List? workouts;

  DailyTaskList({super.key, required this.id, this.workouts});

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;
    final HomeController controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Daily Task" Header
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: ReusableText(
            text: "Daily task",
            size: 24 * autoScale,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Daily Task List
        workouts!.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: workouts!.length,
                itemBuilder: (context, index) {
                  final task = workouts![index];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4 * autoScale),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DailyTaskPage()));
                        // if (!workouts!.contains(task.title)) {
                        //   FirebaseFirestore.instance
                        //       .collection('Daily Plan')
                        //       .doc(id)
                        //       .update({
                        //     'workouts': FieldValue.arrayUnion([task.title])
                        //   });
                        // }
                        // task.isCompleted = !task.isCompleted;
                        // controller.dailyTasks.refresh();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10 * autoScale),
                        decoration: BoxDecoration(
                          color: AppColors.pNoColor,
                          borderRadius: BorderRadius.circular(12 * autoScale),
                        ),
                        child: Row(
                          children: [
                            // Task Image
                            Container(
                              width: 60.0 * autoScale,
                              height: 60.0 * autoScale,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(8 * autoScale),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/chest-workout.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 12 * autoScale),
                            // Task Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Task Title
                                  ReusableText(
                                    text: task['exercise'],
                                    fontWeight: FontWeight.w600,
                                    size: 18 * autoScale,
                                    color: AppColors.pBlack87Color,
                                    decoration: null,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                  // Task Info Chips
                                  Row(
                                    children: [
                                      _buildInfoChip(
                                        iconPath: IconAssets.pClockIcon,
                                        label: task['minutes'].toString(),
                                        color: AppColors.pDarkGreenColor,
                                        backgroundColor: AppColors.pNoColor,
                                      ),
                                      SizedBox(width: 8 * autoScale),
                                      _buildInfoChip(
                                        iconPath: IconAssets.pFireIcon,
                                        label:
                                            task['calories_burned'].toString(),
                                        color: AppColors.pDarkOrangeColor,
                                        backgroundColor: AppColors.pNoColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Completion Status Image Icon
                            Image.asset(
                              IconAssets.pPlayIcon,
                              width: 35 * autoScale,
                              height: 35 * autoScale,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, color: Colors.grey, size: 50.0),
                      SizedBox(height: 10.0),
                      ReusableText(
                        text: "No tasks for today!",
                        color: AppColors.pGreyColor,
                        size: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildInfoChip({
    required String iconPath,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    double autoScale = Get.width / 360;

    return Container(
      padding: EdgeInsets.all(3.0 * autoScale),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16 * autoScale),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 12.0 * autoScale,
            width: 12.0 * autoScale,
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

class _DailyTaskCard extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onTap;
  final List? newWorkouts;
  const _DailyTaskCard({
    required this.task,
    required this.onTap,
    required this.newWorkouts,
  });

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10 * autoScale),
        decoration: BoxDecoration(
          color: newWorkouts!.contains(task.title)
              ? AppColors.pGreen38Color
              : AppColors.pNoColor,
          borderRadius: BorderRadius.circular(12 * autoScale),
        ),
        child: Row(
          children: [
            // Task Image
            Container(
              width: 60.0 * autoScale,
              height: 60.0 * autoScale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8 * autoScale),
                image: DecorationImage(
                  image: AssetImage(task.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12 * autoScale),
            // Task Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  ReusableText(
                    text: task.title,
                    fontWeight: FontWeight.w600,
                    size: 18 * autoScale,
                    color: AppColors.pBlack87Color,
                    decoration: newWorkouts!.contains(task.title)
                        ? TextDecoration.lineThrough
                        : null,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  // Task Info Chips
                  Row(
                    children: [
                      _buildInfoChip(
                        iconPath: IconAssets.pClockIcon,
                        label: task.duration,
                        color: AppColors.pDarkGreenColor,
                        backgroundColor: AppColors.pNoColor,
                      ),
                      SizedBox(width: 8 * autoScale),
                      _buildInfoChip(
                        iconPath: IconAssets.pFireIcon,
                        label: task.calories,
                        color: AppColors.pDarkOrangeColor,
                        backgroundColor: AppColors.pNoColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Completion Status Image Icon
            Image.asset(
              task.isCompleted ? IconAssets.pPlayIcon : IconAssets.pPlayIcon,
              width: 35 * autoScale,
              height: 35 * autoScale,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Method for Info Chips
  Widget _buildInfoChip({
    required String iconPath,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    double autoScale = Get.width / 360;

    return Container(
      padding: EdgeInsets.all(3.0 * autoScale),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16 * autoScale),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 12.0 * autoScale,
            width: 12.0 * autoScale,
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
