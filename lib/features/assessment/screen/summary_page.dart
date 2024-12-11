import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/screen/home_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:psb_app/utils/reusable_button.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double autoScale = Get.width / 360;
    final double screenHeight = Get.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.pWhiteColor,
        elevation: 0,
        centerTitle: true,
        title: ReusableText(
          text: 'Based on your answers, here is your plan:',
          size: 22 * autoScale,
          fontWeight: FontWeight.bold,
          align: TextAlign.center,
          maxLines: 2,
        ),
        toolbarHeight: 100.0,
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColors.pNoColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final workoutPlan = userData['workouts'] as Map<String, dynamic>;
          final overview = workoutPlan['overview'] as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0 * autoScale),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0 * autoScale),
                  ReusableText(
                    text: 'Designed for you',
                    size: 20 * autoScale,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20.0 * autoScale),
                  Container(
                    padding: EdgeInsets.all(16.0 * autoScale),
                    decoration: BoxDecoration(
                      color: AppColors.pPitchColor,
                      borderRadius: BorderRadius.circular(12 * autoScale),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIconTextRow(
                          imagePath: IconAssets.pTargetIcon,
                          label: 'Focus Area',
                          value: overview['focus_area'],
                          autoScale: autoScale,
                        ),
                        SizedBox(height: 10.0 * autoScale),
                        _buildIconTextRow(
                          imagePath: IconAssets.pDurationIcon,
                          label: 'Duration',
                          value: '${overview['workout_duration_minutes']} mins',
                          autoScale: autoScale,
                        ),
                        SizedBox(height: 10.0 * autoScale),
                        _buildIconTextRow(
                          imagePath: IconAssets.pWaterIntakeIcon,
                          label: 'Water Intake',
                          value: overview['daily_water_intake_glass'],
                          autoScale: autoScale,
                        ),
                        SizedBox(height: 10.0 * autoScale),
                        _buildIconTextRow(
                          imagePath: IconAssets.pBurnCaloriesIcon,
                          label: 'Daily burned calories',
                          value: '${overview['daily_calories_burned']} kcal',
                          autoScale: autoScale,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0 * autoScale),
                  ReusableText(
                    text: 'Weekly Schedule',
                    size: 20 * autoScale,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20.0 * autoScale),
                  ...(workoutPlan['weekly_schedule'] as List)
                      .map((day) => _buildPlanItem(
                    '${day['day'].toString().capitalizeFirst}: ${day['focus']}',
                    autoScale,
                  ))
                      .toList(),
                  SizedBox(height: 20.0 * autoScale),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20.0 * autoScale,
            right: 20.0 * autoScale,
            top: 20.0 * autoScale,
            bottom: 40.0 * autoScale
        ),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: ReusableButton(
            text: "GET MY PLAN",
            onPressed: () {
              Get.offAll(() => const HomePage(), transition: Transition.noTransition);
            },
            color: AppColors.pGreenColor,
            fontColor: AppColors.pWhiteColor,
            borderRadius: 30.0 * autoScale,
            size: 18 * autoScale,
            weight: FontWeight.w600,
            removePadding: true,
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextRow({
    required String imagePath,
    required String label,
    required String value,
    required double autoScale,
  }) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 40 * autoScale,
          height: 40 * autoScale,
        ),
        SizedBox(width: 8.0 * autoScale),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: label,
              size: 14 * autoScale,
              fontWeight: FontWeight.w400,
              color: AppColors.pDarkGreyColor,
            ),
            ReusableText(
              text: value,
              size: 16 * autoScale,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanItem(String text, double autoScale) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0 * autoScale, bottom: 16.0 * autoScale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.0 * autoScale),
            child: Icon(Icons.circle, color: AppColors.pGreenColor, size: 8 * autoScale),
          ),
          SizedBox(width: 8.0 * autoScale),
          Expanded(
            child: ReusableText(
              text: text,
              size: 18 * autoScale,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
