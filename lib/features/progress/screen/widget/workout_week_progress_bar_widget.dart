import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class WorkoutChartWidget extends StatelessWidget {
  final double weeklyAverage;
  final List<double> dailyWorkoutMinutes;

  const WorkoutChartWidget({
    super.key,
    required this.weeklyAverage,
    required this.dailyWorkoutMinutes,
  });

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    int weeklyHours = (weeklyAverage / 60).floor();
    int weeklyMinutes = (weeklyAverage % 60).toInt();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0 * autoScale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReusableText(
                    text: "Workout",
                    fontWeight: FontWeight.bold,
                    size: 24 * autoScale,
                  ),
                  ReusableText(
                    text: "Weekly Average",
                    size: 14 * autoScale,
                    color: AppColors.pBGGreyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18 * autoScale,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                              text: "$weeklyHours ",
                              style: const TextStyle(
                                  color: AppColors.pBlackColor)),
                          TextSpan(
                              text: weeklyHours == 1 ? "hr" : "hrs",
                              style: TextStyle(
                                  fontSize: 14 * autoScale,
                                  color: AppColors.pBGGreyColor)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18 * autoScale,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                              text: weeklyMinutes > 0 ? "$weeklyMinutes " : "",
                              style: const TextStyle(
                                  color: AppColors.pBlackColor)),
                          TextSpan(
                              text: (weeklyMinutes == 1) ? "min" : "mins",
                              style: TextStyle(
                                  fontSize: 14 * autoScale,
                                  color: AppColors.pBGGreyColor)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 300, // Assuming max 5 hours (300 minutes) as full height
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      int minutes = rod.toY.toInt();
                      String unit = minutes == 1
                          ? "min"
                          : "mins"; // Adjust unit based on minute value
                      return BarTooltipItem(
                        "$minutes $unit",
                        const TextStyle(
                            color: AppColors.pWhiteColor,
                            fontFamily: 'Poppins'),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false)), // Hide top labels
                  rightTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false)), // Hide right labels
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const days = ["S", "M", "T", "W", "T", "F", "S"];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ReusableText(
                              text: days[value.toInt()], size: 14 * autoScale),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: dailyWorkoutMinutes.asMap().entries.map((entry) {
                  int index = entry.key;
                  double value = entry.value;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        color: AppColors.pOrangeColor,
                        width: 16 * autoScale,
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 300,
                          color: AppColors.pLightGreyColor,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
