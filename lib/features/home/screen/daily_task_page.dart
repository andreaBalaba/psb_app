import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';

import '../../../utils/global_variables.dart';

class DailyTaskPage extends StatefulWidget {
  dynamic data;

  DailyTaskPage({super.key, required this.data});

  @override
  State<DailyTaskPage> createState() => _DailyTaskPageState();
}

class _DailyTaskPageState extends State<DailyTaskPage> {
  bool isDone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ReusableText(
                  text: 'Workout',
                  fontWeight: FontWeight.w600,
                  size: 18,
                  color: AppColors.pBlack87Color,
                  decoration: null,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 350.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(widget.data['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ReusableText(
                  text: widget.data['exercise'],
                  fontWeight: FontWeight.w600,
                  size: 18,
                  color: AppColors.pBlack87Color,
                  decoration: null,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 5,
                ),
                ReusableText(
                  text: 'Set 1 of ${widget.data['sets']}',
                  fontWeight: FontWeight.w200,
                  size: 12,
                  color: AppColors.pBlack87Color,
                  decoration: null,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.green,
                      size: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ReusableText(
                      text: '${widget.data['minutes']}:00',
                      fontWeight: FontWeight.w600,
                      size: 24,
                      color: AppColors.pGreenColor,
                      decoration: null,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: isDone,
                  child: const ReusableText(
                    text: 'Great, you can proceed now !',
                    fontWeight: FontWeight.w600,
                    size: 18,
                    color: AppColors.pBlack87Color,
                    decoration: null,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ReusableText(
                      text: 'Calories burned : ',
                      fontWeight: FontWeight.w600,
                      size: 22,
                      color: AppColors.pBlack87Color,
                      decoration: null,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/icons/BurnCalories.png',
                      height: 35,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ReusableText(
                      text: '${widget.data['calories_burned']} cal',
                      fontWeight: FontWeight.w600,
                      size: 22,
                      color: AppColors.pDarkOrangeColor,
                      decoration: null,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                ReusableButton(
                  text: isDone ? "Finish" : 'Start',
                  onPressed: () async {
                    if (!isDone) {
                      setState(() {
                        isDone = true;
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('Weekly')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        '${DateTime.now().weekday.toString()}.workouts':
                            FieldValue.increment(1),
                      });
                      await FirebaseFirestore.instance
                          .collection('Weekly')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        '${DateTime.now().weekday.toString()}.calories':
                            FieldValue.increment(
                                widget.data['calories_burned']),
                      });
                      await FirebaseFirestore.instance
                          .collection('Weekly')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        '${DateTime.now().weekday.toString()}.mins':
                            FieldValue.increment(widget.data['minutes']),
                      });
                      Navigator.pop(context);
                    }
                  },
                  color: AppColors.pGreenColor,
                  fontColor: AppColors.pWhiteColor,
                  borderRadius: 100,
                  size: 22,
                  weight: FontWeight.w600,
                  removePadding: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
