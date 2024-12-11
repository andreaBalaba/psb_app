import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class UserCards extends StatelessWidget {
  const UserCards({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final autoScale = screenWidth / 400;
    final cardHeight = 108 * autoScale;

    return Row(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Equipments')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(child: Text('Error'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                );
              }

              final data = snapshot.requireData;
              return Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16 * autoScale),
                  ),
                  color: AppColors.pOrangeColor,
                  elevation: 3,
                  child: Container(
                    height: cardHeight,
                    padding: EdgeInsets.all(12 * autoScale),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ReusableText(
                          text: data.docs.length.toString(),
                          size: 30 * autoScale,
                          fontWeight: FontWeight.bold,
                        ),
                        ReusableText(
                          text: "Equipment Captured",
                          size: 14 * autoScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pBlack87Color,
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        SizedBox(width: 10 * autoScale),
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
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              dynamic data = snapshot.data;

              List workouts = data['workouts']['weekly_schedule']
                  [DateTime.now().weekday - 1]['exercises'];
              return Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16 * autoScale),
                  ),
                  color: AppColors.pLightGreenColor,
                  elevation: 3,
                  child: Container(
                    height: cardHeight, // Fixed height for all cards
                    padding: EdgeInsets.all(12 * autoScale),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center-align content
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ReusableText(
                          text: workouts.length.toString(),
                          size: 30 * autoScale,
                          fontWeight: FontWeight.bold,
                        ),
                        ReusableText(
                          text: "Workout Plans",
                          size: 14 * autoScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pBlack87Color,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }
}
