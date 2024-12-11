import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class WeeklyProgressCard extends StatelessWidget {
  WeeklyProgressCard({super.key});

  final autoScale = Get.width / 400;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading'));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          dynamic userData = snapshot.data;
          List workouts1 =
              userData['workouts']['weekly_schedule'][0]['exercises'];
          List workouts2 =
              userData['workouts']['weekly_schedule'][1]['exercises'];
          List workouts3 =
              userData['workouts']['weekly_schedule'][2]['exercises'];
          List workouts4 =
              userData['workouts']['weekly_schedule'][3]['exercises'];
          List workouts5 =
              userData['workouts']['weekly_schedule'][4]['exercises'];
          List workouts6 =
              userData['workouts']['weekly_schedule'][5]['exercises'];
          List workouts7 =
              userData['workouts']['weekly_schedule'][6]['exercises'];

          int total = workouts1.length +
              workouts2.length +
              workouts3.length +
              workouts4.length +
              workouts5.length +
              workouts6.length +
              workouts7.length;
          return Container(
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Weekly')
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

                  int total1 = data['1']['workouts'] +
                      data['2']['workouts'] +
                      data['3']['workouts'] +
                      data['4']['workouts'] +
                      data['5']['workouts'] +
                      data['6']['workouts'] +
                      data['7']['workouts'];

                  int totalCal = data['1']['calories'] +
                      data['2']['calories'] +
                      data['3']['calories'] +
                      data['4']['calories'] +
                      data['5']['calories'] +
                      data['6']['calories'] +
                      data['7']['calories'];
                  return Card(
                    color: AppColors.pOrangeColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      padding: EdgeInsets.all(16.0 * autoScale),
                      constraints: BoxConstraints(
                        minHeight: 150 * autoScale,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: CircularPercentIndicator(
                                    radius: 50.0 * autoScale,
                                    lineWidth: 7.5 * autoScale,
                                    percent: (total1 / total) * 0.1,
                                    center: ReusableText(
                                      text:
                                          "${((total1 / total) * 100).toStringAsFixed(0)}%",
                                      size: 30 * autoScale,
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
                              SizedBox(width: 10 * autoScale),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(
                                      text: "Weekly Progress",
                                      size: 18 * autoScale,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 15 * autoScale),
                                    _buildProgressRow(
                                        "Total workouts:", total.toString()),
                                    _buildProgressRow(
                                        "Calories burned:", "$totalCal kcal"),
                                    _buildProgressRow(
                                        "Total distance:", "0 km"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        });
  }

  Widget _buildProgressRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ReusableText(
          text: title,
          fontWeight: FontWeight.w500,
          size: 15 * autoScale,
        ),
        ReusableText(
          text: value,
          size: 15 * autoScale,
        ),
      ],
    );
  }
}
