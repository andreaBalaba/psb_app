import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class WorkoutBarChart extends StatefulWidget {
  WorkoutBarChart({super.key});

  final autoScale = Get.width / 360;

  @override
  State<WorkoutBarChart> createState() => _WorkoutBarChartState();
}


class _WorkoutBarChartState extends State<WorkoutBarChart> {
  // Sample workout data for each day of the week
  final List<int> dailyWorkoutMinutes = [90, 45, 120, 75, 60, 250, 30];

  final List<String> weekDays = ["S", "M", "T", "W", "T", "F", "S"];

  String formatTime(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    return hours > 0
        ? '$hours hr ${mins > 0 ? '$mins min' : ''}'
        : '$mins min';
  }

  // Determine bar color based on workout duration
  Color _getBarColor(int minutes) {
    if (minutes >= 180) {
      return AppColors.pGreenColor;
    } else if (minutes >= 60) {
      return AppColors.pOrangeColor;
    } else {
      return AppColors.pOrangeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Workout header
        _buildWorkoutHeader(),

        // Time summary row
        _buildTimeSummary(),

        const SizedBox(height: 16),

        // Bar Chart
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(_buildBarChartData()),
        ),
      ],
    );
  }

  Widget _buildWorkoutHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: "Workout",
            fontWeight: FontWeight.bold,
            size: 24 * widget.autoScale,
          ),
          ReusableText(
            text: "Weekly Average",
            size: 16 * widget.autoScale,
            color: AppColors.pBGGreyColor,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeSummaryText(2, 25),
        _buildTimeSummaryText(1, 9),
      ],
    );
  }

  Widget _buildTimeSummaryText(int hours, int minutes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18 * widget.autoScale,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
                text: "$hours ",
                style: const TextStyle(color: AppColors.pBlackColor)
            ),
            TextSpan(
                text: hours == 1 ? "hr " : "hrs ",
                style: TextStyle(
                    fontSize: 14 * widget.autoScale,
                    color: AppColors.pBGGreyColor
                )
            ),
            if (minutes > 0)
              TextSpan(
                  text: "$minutes ",
                  style: const TextStyle(color: AppColors.pBlackColor)
              ),
            if (minutes > 0)
              TextSpan(
                  text: (minutes == 1) ? "min" : "mins",
                  style: TextStyle(
                      fontSize: 14 * widget.autoScale,
                      color: AppColors.pBGGreyColor
                  )
              ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Configure Bar Chart Data
  BarChartData _buildBarChartData() {
    return BarChartData(
      // Maximum Y-axis value with 20% padding
      maxY: (dailyWorkoutMinutes.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),

      // Bar touch configurations
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipRoundedRadius: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            int minutes = rod.toY.toInt();
            return BarTooltipItem(
              formatTime(minutes),
              const TextStyle(
                  color: AppColors.pWhiteColor,
                  fontFamily: 'Poppins'
              ),
            );
          },
        ),
      ),

      // Titles configuration
      titlesData: _buildTitlesData(),

      // Remove grid and border
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),

      // Bar groups
      barGroups: _buildBarGroups(),
    );
  }

  // Configure Titles Data
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      // Hide unnecessary titles
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

      // Configure bottom titles (day abbreviations)
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ReusableText(
                text: weekDays[value.toInt()],
                size: 14 * widget.autoScale,
              ),
            );
          },
          reservedSize: 28,
        ),
      ),
    );
  }

  // Build Bar Groups with dynamic coloring
  List<BarChartGroupData> _buildBarGroups() {
    return dailyWorkoutMinutes.asMap().entries.map((entry) {
      int index = entry.key;
      int value = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),
            color: _getBarColor(value),
            width: 16 * widget.autoScale,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: (dailyWorkoutMinutes.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
              color: AppColors.pLightGreyColor,
            ),
          ),
        ],
      );
    }).toList();
  }
}