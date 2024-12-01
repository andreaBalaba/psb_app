import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:psb_app/features/home/controller/home_controller.dart';
import 'package:psb_app/features/settings/screen/setting_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final HomeController homeController = Get.put(HomeController());
  double autoScale = Get.width / 400;

  List<int> dailyWorkoutMinutes = [90, 45, 120, 75, 60, 250, 30];

  String formatTime(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    return '$hours hr ${mins > 0 ? '$mins min' : ''}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        surfaceTintColor: AppColors.pNoColor,
        actions: [
          IconButton(
            icon: Image.asset(
              IconAssets.pSettingIcon,
              height: 30 * autoScale,
            ),
            onPressed: () {
              Get.to(() => const SettingsPage(), transition: Transition.rightToLeft);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16 * autoScale, vertical: 12 * autoScale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Section
              Center(
                child: CircleAvatar(
                  backgroundImage: const AssetImage(IconAssets.pUserIcon),
                  radius: 50 * autoScale,
                ),
              ),
              SizedBox(height: 16 * autoScale),
              // Username Text
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 40 * autoScale),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Loading'));
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Something went wrong'));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          dynamic data = snapshot.data;
                          return Flexible(
                            child: ReusableText(
                              text: data['name'],
                              size: 20 * autoScale,
                              fontWeight: FontWeight.w500,
                              color: AppColors.pBlackColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20 * autoScale,
                        color: AppColors.pGreyColor,
                      ),
                      onPressed: () {
                        // Implement edit functionality here
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8 * autoScale),

              // Cards Section
              Row(
                children: [
                  // Equipments Captured Card
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16 * autoScale),
                      ),
                      color: AppColors.pOrangeColor,
                      child: Container(
                        height: 100 * autoScale,
                        padding: EdgeInsets.all(16 * autoScale),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: "10",
                              size: 32 * autoScale,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 8 * autoScale),
                            ReusableText(
                              text: "Equipments Captured",
                              size: 14 * autoScale,
                              fontWeight: FontWeight.w500,
                              color: AppColors.pDarkGreyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * autoScale),

                  // Workout Plans Card
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16 * autoScale),
                      ),
                      color: AppColors.pLightGreenColor,
                      elevation: 3,
                      child: Container(
                        height: 100 * autoScale,
                        padding: EdgeInsets.all(16 * autoScale),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: "3",
                              size: 32 * autoScale,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 8 * autoScale),
                            ReusableText(
                              text: "Workout Plans",
                              size: 14 * autoScale,
                              fontWeight: FontWeight.w500,
                              color: AppColors.pDarkGreyColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16 * autoScale),

              // Weekly Progress Card
              Card(
                color: AppColors.pOrangeColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16.0 * autoScale),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Progress Circle
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: CircularPercentIndicator(
                                radius: 55.0 * autoScale,
                                lineWidth: 7.5 * autoScale,
                                percent: 0.3,
                                center: ReusableText(
                                  text: "25%",
                                  size: 32 * autoScale,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pWhiteColor,
                                  shadows: const [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.black26,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                progressColor: AppColors.pGreenColor,
                                backgroundColor: AppColors.pMGreyColor,
                                circularStrokeCap: CircularStrokeCap.round,
                              ),
                            ),
                          ),
                          SizedBox(width: 8 * autoScale),

                          // Progress Info
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Weekly Progress Title
                                ReusableText(
                                  text: "Weekly Progress",
                                  size: 20 * autoScale,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: 8 * autoScale),

                                // Total Workouts
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ReusableText(
                                      text: "Total workouts",
                                      fontWeight: FontWeight.w500,
                                      size: 16 * autoScale,
                                    ),
                                    ReusableText(
                                      text: "20",
                                      size: 14 * autoScale,
                                      color: AppColors.pWhiteColor,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 2.0,
                                          color: Colors.black26,
                                          offset: Offset(0.0, 0.3),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Calories Burned
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ReusableText(
                                      text: "Calories burned",
                                      fontWeight: FontWeight.w500,
                                      size: 16 * autoScale,
                                    ),
                                    ReusableText(
                                      text: "3000 kcal",
                                      size: 14 * autoScale,
                                      color: AppColors.pWhiteColor,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 2.0,
                                          color: Colors.black26,
                                          offset: Offset(0.0, 0.3),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Total Distance
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ReusableText(
                                      text: "Total distance",
                                      fontWeight: FontWeight.w500,
                                      size: 16 * autoScale,
                                    ),
                                    ReusableText(
                                      text: "1,000 km",
                                      size: 14 * autoScale,
                                      color: AppColors.pWhiteColor,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 2.0,
                                          color: Colors.black26,
                                          offset: Offset(0.0, 0.3),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16 * autoScale),
              Column(
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
                                  const TextSpan(text: "2 ", style: TextStyle(color: AppColors.pBlackColor)),
                                  TextSpan(text: 2 == 1 ? "hr " : "hrs ", style: TextStyle(fontSize: 14 * autoScale, color: AppColors.pBGGreyColor)),
                                  const TextSpan(text: 25 > 0 ? "25 " : "", style: TextStyle(color: AppColors.pBlackColor)),
                                  TextSpan(text: (25 == 1) ? "min" : "mins", style: TextStyle(fontSize: 14 * autoScale, color: AppColors.pBGGreyColor)),
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
                                  const TextSpan(text: "1 ", style: TextStyle(color: AppColors.pBlackColor)),
                                  TextSpan(text: 1 == 1 ? "hr " : "hrs ", style: TextStyle(fontSize: 14 * autoScale, color: AppColors.pBGGreyColor)),
                                  const TextSpan(text: 9 > 0 ? "9 " : "", style: TextStyle(color: AppColors.pBlackColor)),
                                  TextSpan(text: (9 == 1) ? "min" : "mins", style: TextStyle(fontSize: 14 * autoScale, color: AppColors.pBGGreyColor)),
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
                        maxY: (dailyWorkoutMinutes.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipRoundedRadius: 8,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              int minutes = rod.toY.toInt();
                              return BarTooltipItem(
                                formatTime(minutes),
                                const TextStyle(color: AppColors.pWhiteColor, fontFamily: 'Poppins'),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const days = ["S", "M", "T", "W", "T", "F", "S"];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ReusableText(
                                    text: days[value.toInt()],
                                    size: 14 * autoScale,
                                  ),
                                );
                              },
                              reservedSize: 28,
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: dailyWorkoutMinutes.asMap().entries.map((entry) {
                          int index = entry.key;
                          int value = entry.value;

                          Color barColor;
                          if (value >= 180) {
                            barColor = AppColors.pLightGreenColor;
                          } else if (value >= 60) {
                            barColor = AppColors.pOrangeColor;
                          } else {
                            barColor = AppColors.pOrangeColor;
                          }

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: value.toDouble(),
                                color: barColor,
                                width: 16 * autoScale,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: (dailyWorkoutMinutes.reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
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
              SizedBox(height: 20 * autoScale),
            ],
          ),
        ),
      ),
    );
  }
}
