import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/progress/controller/progress_controller.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ProgressCardsWidget extends StatefulWidget {
  int sleep;
  int calories;
  int water;
  int steps;
  ProgressCardsWidget(
      {super.key,
      required this.sleep,
      required this.calories,
      required this.steps,
      required this.water});

  @override
  State<ProgressCardsWidget> createState() => _ProgressCardsWidgetState();
}

class _ProgressCardsWidgetState extends State<ProgressCardsWidget> {
  final ProgressController controller = Get.put(ProgressController());
  double autoScale = Get.width / 360;

  int tempWaterIntake = 0; // Temporary variable for dialog

  int tempSleepHours = 0; // Temporary variable for sleep dialog

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0 * autoScale),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _ProgressCard(
                  title: "Calories",
                  value: "${widget.calories}",
                  unit: "Kcal",
                  color: AppColors.pOrangeColor,
                  imagePath: IconAssets.pCaloriesIcon,
                ),
              ),
              SizedBox(width: 16 * autoScale),
              Expanded(
                child: _ProgressCard(
                  title: "Steps",
                  value: "${widget.steps}",
                  unit: widget.steps <= 1 ? "Step" : "Steps",
                  color: AppColors.pLightGreenColor,
                  imagePath: IconAssets.pStepIcon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _ProgressCard(
                  title: "Water",
                  value: "${widget.water}/16",
                  unit: "Glass",
                  color: AppColors.pLightBlueColor,
                  imagePath: IconAssets.pWaterIcon,
                  showPlusIcon: true,
                  onPlusIconPressed: _showWaterIntakeDialog,
                ),
              ),
              SizedBox(width: 16 * autoScale),
              Expanded(
                child: _ProgressCard(
                  title: "Sleep",
                  value: "${widget.sleep}",
                  unit: widget.sleep <= 1 ? "Hour" : "Hours",
                  color: AppColors.pLightPurpleColor,
                  imagePath: IconAssets.pSleepIcon,
                  showPlusIcon: true,
                  onPlusIconPressed: _showSleepHoursDialog,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showWaterIntakeDialog() {
    tempWaterIntake = widget.water;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              backgroundColor: AppColors.pBGWhiteColor,
              title: ReusableText(
                text: "Water Intake",
                size: 18 * autoScale,
                fontWeight: FontWeight.bold,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ReusableText(
                      text:
                          "Tap the glasses to select how many you've had today.",
                      size: 14 * autoScale,
                      color: Colors.black54,
                      align: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(16, (index) {
                      return GestureDetector(
                        onTap: () {
                          setStateDialog(() {
                            tempWaterIntake = index + 1;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  index < tempWaterIntake
                                      ? IconAssets.pGlassWaterIcon
                                      : IconAssets.pGlassIcon,
                                  width: 40,
                                  height: 50,
                                ),
                                ReusableText(
                                  text: '${index + 1}',
                                  size: 12 * autoScale,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'water': tempWaterIntake});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.pLightBlueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: ReusableText(
                        text: "Save",
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        size: 14 * autoScale,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSleepHoursDialog() {
    tempSleepHours = widget.sleep;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              backgroundColor: AppColors.pBGWhiteColor,
              title: ReusableText(
                text: "Sleep",
                size: 18 * autoScale,
                fontWeight: FontWeight.bold,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ReusableText(
                      text: "Adjust the hours of sleep you've had today.",
                      size: 14 * autoScale,
                      color: Colors.black54,
                      align: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, size: 40 * autoScale),
                        color: AppColors.pLightPurpleColor,
                        onPressed: () {
                          setStateDialog(() {
                            if (tempSleepHours > 0) {
                              tempSleepHours--;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 30),
                      ReusableText(
                        text: '$tempSleepHours',
                        size: 40 * autoScale,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: Icon(Icons.add, size: 40 * autoScale),
                        color: AppColors.pLightPurpleColor,
                        onPressed: () {
                          setStateDialog(() {
                            if (tempSleepHours < 24) {
                              tempSleepHours++;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'sleep': tempSleepHours});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.pLightPurpleColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: ReusableText(
                        text: "Save",
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        size: 14 * autoScale,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// Internal ProgressCard widget within ProgressCardsWidget
class _ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;
  final String imagePath;
  final bool showPlusIcon;
  final VoidCallback? onPlusIconPressed;

  const _ProgressCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.imagePath,
    this.showPlusIcon = false,
    this.onPlusIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return Container(
      height: 120 * autoScale,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15 * autoScale),
        boxShadow: [
          BoxShadow(
            color: AppColors.pGrey400Color,
            blurRadius: 3 * autoScale,
            offset: Offset(0, 2 * autoScale),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0 * autoScale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ReusableText(
                        text: title,
                        size: 20 * autoScale,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      imagePath,
                      width: 24 * autoScale,
                      height: 24 * autoScale,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const Spacer(),
                ReusableText(
                  text: value,
                  size: 28 * autoScale,
                  fontWeight: FontWeight.bold,
                ),
                ReusableText(
                  text: unit,
                  size: 14 * autoScale,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          if (showPlusIcon)
            Positioned(
              bottom: 8 * autoScale,
              right: 8 * autoScale,
              child: GestureDetector(
                onTap: onPlusIconPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pWhiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pMGreyColor,
                        blurRadius: 8 * autoScale,
                        offset: Offset(0, 4 * autoScale),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    size: 20 * autoScale,
                    color: color,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
