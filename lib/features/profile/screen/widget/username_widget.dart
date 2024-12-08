import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class UserHeader extends StatelessWidget {

  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final autoScale = Get.width / 400;

    return Column(
      children: [
        Center(
          child: CircleAvatar(
            backgroundImage: const AssetImage(IconAssets.pUserIcon),
            radius: 50 * autoScale,
          ),
        ),
        SizedBox(height: 16 * autoScale),
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
      ],
    );
  }
}