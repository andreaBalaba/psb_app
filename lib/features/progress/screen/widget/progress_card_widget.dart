import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/progress/controller/progress_controller.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ProgressCardsWidget extends StatefulWidget {
  const ProgressCardsWidget({super.key});

  @override
  State<ProgressCardsWidget> createState() => _ProgressCardsWidgetState();
}

class _ProgressCardsWidgetState extends State<ProgressCardsWidget> {
  final ProgressController controller = Get.put(ProgressController());
  double autoScale = Get.width / 360;
  int waterIntake = 0;
  int tempWaterIntake = 0; // Temporary variable for dialog
  int sleepHours = 0;
  int tempSleepHours = 0; // Temporary variable for sleep dialog
  int caloriesBurned = 300;

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
                  value: "$caloriesBurned",
                  unit: "Kcal",
                  color: AppColors.pOrangeColor,
                  imagePath: IconAssets.pCaloriesIcon,
                ),
              ),
              SizedBox(width: 16 * autoScale),
              Expanded(
                child: GestureDetector(
                  onTap: _showStepsDialog,
                  child: _ProgressCard(
                    title: "Steps",
                    value: "${controller.stepCount.value}",
                    unit: controller.todayStepCount.value <= 1 ? "Step" : "Steps",
                    color: AppColors.pLightGreenColor,
                    imagePath: IconAssets.pStepIcon,
                  ),
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
                  value: "$waterIntake/16",
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
                  value: "$sleepHours",
                  unit: sleepHours <= 1 ? "Hour" : "Hours",
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

  void _showStepsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: AppColors.pBGWhiteColor,
          contentPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          children: [
            ReusableText(
              text: "Steps Tracking",
              size: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.pLightGreenColor,
                    unselectedLabelColor: AppColors.pGreyColor,
                    indicatorColor: AppColors.pLightGreenColor,
                    tabs: [
                      Tab(text: "Hourly"),
                      Tab(text: "7 Days"),
                      Tab(text: "30 Days"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      children: [
                        // Hourly Steps Chart
                        _buildBarChart(
                          controller.hourlySteps,
                          maxY: 200,
                          labelInterval: 3, // Display every 3 hours
                          xLabels: List.generate(24, (i) => '${i}:00'),
                        ),
                        // Last 7 Days Chart
                        _buildBarChart(
                          controller.last7DaysSteps,
                          maxY: 18000,
                          labelInterval: 1, // Show each day
                          xLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                        ),
                        // Last 30 Days Chart
                        _buildBarChart(
                          controller.last30DaysSteps,
                          maxY: 18000,
                          labelInterval: 5, // Display every 5th day to avoid clutter
                          xLabels: List.generate(30, (i) {
                            final date = DateTime.now().subtract(Duration(days: 29 - i));
                            return "${date.month}/${date.day}";
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildBarChart(List<int> data, {required double maxY, required List<String> xLabels, int labelInterval = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 5,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: labelInterval.toDouble(),
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < xLabels.length && index % labelInterval == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Transform.rotate(
                        angle: 0, // Rotate labels slightly if there are many
                        child: Text(
                          xLabels[index],
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(color: Colors.grey.shade300),
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          barGroups: data.asMap().entries.map((entry) {
            int index = entry.key;
            int value = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value.toDouble(),
                  color: Colors.orange,
                  width: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }




  void _showWaterIntakeDialog() {
    tempWaterIntake = waterIntake;
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
                      text: "Tap the glasses to select how many you've had today.",
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
                                  index < tempWaterIntake ? IconAssets.pGlassWaterIcon : IconAssets.pGlassIcon,
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
                      onPressed: () {
                        setState(() {
                          waterIntake = tempWaterIntake;
                        });
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
    tempSleepHours = sleepHours;
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
                      onPressed: () {
                        setState(() {
                          sleepHours = tempSleepHours;
                        });
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
