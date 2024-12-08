import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/controller/home_controller.dart';
import 'package:psb_app/features/profile/screen/widget/equip_and_workout_card_widget.dart';
import 'package:psb_app/features/profile/screen/widget/username_widget.dart';
import 'package:psb_app/features/profile/screen/widget/weekly_progress_card_widget.dart';
import 'package:psb_app/features/profile/screen/widget/workout_bar_chart_widget.dart';
import 'package:psb_app/features/settings/screen/setting_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final HomeController homeController = Get.put(HomeController());
  final double autoScale = Get.width / 360;

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
              const UserHeader(),
              const UserCards(),
              SizedBox(height: 12 * autoScale),
              WeeklyProgressCard(),
              SizedBox(height: 8 * autoScale),
              WorkoutBarChart(),
              SizedBox(height: 20 * autoScale),
            ],
          ),
        ),
      ),
    );
  }
}