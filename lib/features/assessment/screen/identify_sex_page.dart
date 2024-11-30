import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:psb_app/features/assessment/controller/assessment_controller.dart';
import 'package:psb_app/features/assessment/screen/measure_it_right_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdentifySexPage extends StatefulWidget {
  const IdentifySexPage({super.key});

  @override
  State<IdentifySexPage> createState() => _IdentifySexPageState();
}

class _IdentifySexPageState extends State<IdentifySexPage> {
  final AssessmentController controller = Get.put(AssessmentController());
  final List<String> choices = ["Male", "Female"];
  final List<String> images = [
    ImageAssets.pMenGenderPic,
    ImageAssets.pWomenGenderPic
  ];
  double autoScale = Get.width / 400;

  Future<void> saveGenderPreference(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'selectedGender', choices[index]); // Save gender choice
  }

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.pBGWhiteColor,
        surfaceTintColor: AppColors.pNoColor,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded,
                      size: 28 * autoScale, color: AppColors.pBlackColor),
                  padding: const EdgeInsets.all(8.0),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReusableText(
                    text: "Goal",
                    size: 20 * autoScale,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: LinearProgressIndicator(
                      value: 0.35,
                      minHeight: 9.0 * autoScale,
                      color: AppColors.pGreenColor,
                      backgroundColor: AppColors.pMGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(height: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: screenWidth * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28 * autoScale,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                children: const [
                  TextSpan(
                      text: "Getting there",
                      style: TextStyle(color: AppColors.pBlackColor)),
                  TextSpan(
                      text: "!",
                      style: TextStyle(color: AppColors.pSOrangeColor)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            ReusableText(
              text: "Identify your sex",
              size: 18 * autoScale,
              fontWeight: FontWeight.w300,
              align: TextAlign.center,
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: choices.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        controller.setGender(index);
                        controller.selectedIdentifySexIndex(index);
                        box.write('sex', choices[index]);
                      });
                      await saveGenderPreference(
                          index); // Save preference on selection
                    },
                    child: Obx(
                      () => AnimatedScale(
                        scale:
                            controller.selectedIdentifySexIndex.value == index
                                ? 0.7
                                : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                images[index],
                                width: 150 * autoScale,
                                height: 150 * autoScale,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10.0),
                              ReusableText(
                                text: choices[index],
                                fontWeight:
                                    controller.selectedIdentifySexIndex.value ==
                                            index
                                        ? FontWeight.bold
                                        : FontWeight.w300,
                                size: 18 * autoScale,
                                color:
                                    controller.selectedIdentifySexIndex.value ==
                                            index
                                        ? AppColors.pGreenColor
                                        : AppColors.pDarkGreyColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20.0 * autoScale,
            right: 20.0 * autoScale,
            top: 20.0 * autoScale,
            bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: Obx(
            () => ReusableButton(
              text: "Next",
              onPressed: controller.selectedIdentifySexIndex.value == -1
                  ? null
                  : () async {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        'gender': controller.selectedIdentifySexIndex.value == 0
                            ? 'Male'
                            : 'Female',
                      }).whenComplete(
                        () {
                          Get.to(() => const MeasureItRightPage(),
                              transition: Transition.noTransition);
                        },
                      );
                    },
              color: controller.selectedIdentifySexIndex.value == -1
                  ? AppColors.pNoColor
                  : AppColors.pGreenColor,
              fontColor: AppColors.pWhiteColor,
              borderRadius: 0,
              size: 18 * autoScale,
              weight: FontWeight.w600,
              removePadding: true,
            ),
          ),
        ),
      ),
    );
  }
}
