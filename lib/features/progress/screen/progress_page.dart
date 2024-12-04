import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/screen/widget/daily_task_widget.dart';
import 'package:psb_app/features/progress/controller/progress_controller.dart';
import 'package:psb_app/features/progress/screen/widget/progress_card_widget.dart';
import 'package:psb_app/features/progress/screen/widget/workout_week_progress_bar_widget.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ProgressPage extends StatefulWidget {
  final String id;
  final List? workouts;
  final dynamic data;

  const ProgressPage(
      {super.key, required this.id, this.workouts, required this.data});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final ProgressController controller = Get.put(ProgressController());
  bool _showShadow = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.scrollController.hasClients &&
          controller.scrollController.offset > 0) {
        setState(() {
          _showShadow = true;
        });
      }
    });

    controller.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.scrollController.offset > 0 && !_showShadow) {
      setState(() {
        _showShadow = true;
      });
    } else if (controller.scrollController.offset <= 0 && _showShadow) {
      setState(() {
        _showShadow = false;
      });
    }
  }

  @override
  void dispose() {
    controller.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  int getWorkouts() {
    int sum = 0;
    for (int i = 0; i < widget.workouts!.length; i++) {
      setState(() {
        sum += int.parse(widget.workouts![i]['minutes'].toString());
      });
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        title: ReusableText(
          text: 'Today Progress',
          fontWeight: FontWeight.bold,
          size: 20 * autoScale,
        ),
        backgroundColor: AppColors.pBGWhiteColor,
        elevation: _showShadow ? 6.0 : 0.0,
        shadowColor: Colors.black26,
        surfaceTintColor: AppColors.pNoColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        //controller: controller.scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  return ProgressCardsWidget(
                    sleep: data['sleep'],
                    calories: widget.data['calories'],
                    steps: widget.data['steps'],
                    water: data['water'],
                  );
                }),
            const SizedBox(height: 20),
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

                // Check for data integrity before proceeding
                if (data == null ||
                    data['workouts'] == null ||
                    data['workouts']['weekly_schedule'] == null ||
                    widget.workouts == null) {
                  return const Center(child: Text('Invalid data structure'));
                }

                // Helper method to calculate sum for a specific day
                int calculateDailySum(int dayIndex) {
                  List<dynamic> exercises = data['workouts']['weekly_schedule']
                      [dayIndex]['exercises'];
                  int sum = 0;
                  for (int i = 0; i < exercises.length; i++) {
                    if (i < widget.workouts!.length &&
                        widget.workouts![i]['minutes'] != null) {
                      sum +=
                          int.parse(widget.workouts![i]['minutes'].toString());
                    }
                  }
                  return sum;
                }

                // Calculate sums for each day of the week
                int sum1 = calculateDailySum(0);
                int sum2 = calculateDailySum(1);
                int sum3 = calculateDailySum(2);
                int sum4 = calculateDailySum(3);
                int sum5 = calculateDailySum(4);
                int sum6 = calculateDailySum(5);
                int sum7 = calculateDailySum(6);

                return WorkoutChartWidget(
                  weeklyAverage:
                      (sum1 + sum2 + sum3 + sum4 + sum5 + sum6 + sum7) / 7,
                  dailyWorkoutMinutes: [
                    sum1.toDouble(),
                    sum2.toDouble(),
                    sum3.toDouble(),
                    sum4.toDouble(),
                    sum5.toDouble(),
                    sum6.toDouble(),
                    sum7.toDouble(),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            DailyTaskList(
              id: widget.id,
              workouts: widget.workouts,
            ),
          ],
        ),
      ),
    );
  }
}
