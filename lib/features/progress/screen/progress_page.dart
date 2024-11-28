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
                    data['workouts']['weekly_schedule'] == null) {
                  return const Center(child: Text('Invalid data structure'));
                }

                int sum1 = 0;
                for (int i = 0;
                    i <
                        data['workouts']['weekly_schedule'][0]['exercises']
                            .length;
                    i++) {
                  sum1 += int.parse(widget.workouts![i]['minutes'].toString());
                }
                int sum2 = 0;
                for (int i = 0;
                    i <
                        data['workouts']['weekly_schedule'][1]['exercises']
                            .length;
                    i++) {
                  sum2 += int.parse(widget.workouts![i]['minutes'].toString());
                }
                int sum3 = 0;
                for (int i = 0;
                    i <
                        data['workouts']['weekly_schedule'][2]['exercises']
                            .length;
                    i++) {
                  sum3 += int.parse(widget.workouts![i]['minutes'].toString());
                }
                int sum4 = 0;
                for (int i = 0;
                    i <
                        data['workouts']['weekly_schedule'][3]['exercises']
                            .length;
                    i++) {
                  sum4 += int.parse(widget.workouts![i]['minutes'].toString());
                }
                int sum5 = 0;
                for (int i = 0;
                    i <
                        data['workouts']['weekly_schedule'][4]['exercises']
                            .length;
                    i++) {
                  sum5 += int.parse(widget.workouts![i]['minutes'].toString());
                }
                int sum6 = 0;
                for (int i = 0;
                    i <
                        data['workouts']['weekly_schedule'][5]['exercises']
                            .length;
                    i++) {
                  sum6 += int.parse(widget.workouts![i]['minutes'].toString());
                }
                int sum7 = 0;
                for (int i = 0;
                    i <
                        data['workouts']['weekly_schedule'][6]['exercises']
                            .length;
                    i++) {
                  sum7 += int.parse(widget.workouts![i]['minutes'].toString());
                }

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
                  ], // Dummy data for daily minutes
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
