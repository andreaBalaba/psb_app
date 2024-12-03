import 'package:flutter/material.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';

import '../../../utils/global_variables.dart';

class DailyTaskPage extends StatelessWidget {
  const DailyTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    image: const DecorationImage(
                      image: AssetImage('assets/images/chest-workout.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const ReusableText(
                  text: 'Flat bench press ',
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
                const ReusableText(
                  text: 'Set of 5',
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: Colors.green,
                      size: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ReusableText(
                      text: '0:00',
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
                const ReusableText(
                  text: 'Great, you can proceed now !',
                  fontWeight: FontWeight.w600,
                  size: 18,
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
                    const ReusableText(
                      text: '300 cal',
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
                  text: "Finish",
                  onPressed: () {
                    Navigator.pop(context);
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
