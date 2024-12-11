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
                  final TextEditingController nameController = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const ReusableText(
                          text: 'Please enter your name',
                          size: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pBlackColor,
                          align: TextAlign.center,
                        ),
                        content: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 16 * autoScale, color: AppColors.pGreyColor),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        actionsPadding: EdgeInsets.zero,
                        actions: [
                          SizedBox(height: 16 * autoScale),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(color: Colors.grey.shade300),
                                        ),
                                      ),
                                      child: const ReusableText(
                                        text: 'Cancel',
                                        size: 16,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      if (nameController.text.isNotEmpty) {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .update({
                                            'name': nameController.text.trim(),
                                          });
                                          Navigator.of(context).pop();
                                        } catch (e) {
                                          print('Error updating name: $e');
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      child: const ReusableText(
                                        text: 'Save',
                                        size: 16,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}