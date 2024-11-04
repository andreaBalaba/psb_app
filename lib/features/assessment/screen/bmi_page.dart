import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/controller/assessment_controller.dart';
import 'package:psb_app/features/assessment/screen/what_target_weight_page.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmiCalculationPage extends StatefulWidget {
  const BmiCalculationPage({super.key});

  @override
  State<BmiCalculationPage> createState() => _BmiCalculationPageState();
}

class _BmiCalculationPageState extends State<BmiCalculationPage> {
  final AssessmentController controller = Get.put(AssessmentController());
  final double autoScale = Get.width / 400;

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
                  icon: Icon(Icons.arrow_back_rounded, size: 28 * autoScale, color: AppColors.pBlackColor),
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
                    text: "Body data",
                    size: 20 * autoScale,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: LinearProgressIndicator(
                      value: 0.45,
                      minHeight: 9.0 * autoScale,
                      color: AppColors.pGreenColor,
                      backgroundColor: AppColors.pMGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: ReusableText(
                    text: "Skip",
                    color: AppColors.pGreenColor,
                    fontWeight: FontWeight.w500,
                    size: 14 * autoScale,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: screenWidth * 0.01),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 28 * autoScale,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                    children: const [
                      TextSpan(text: "Measure ", style: TextStyle(color: AppColors.pSOrangeColor)),
                      TextSpan(text: "it right!", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20 * autoScale),
              child: Center(
                child: ListView(
                  children: [
                    const SizedBox(height: 40.0),
                    _buildInputRow(
                      label: "Height (cm)",
                      controller: controller.heightController,
                      focusNode: controller.heightFocus,
                      textInputAction: TextInputAction.next, // "Next" for Height
                    ),
                    SizedBox(height: 40 * autoScale),
                    _buildInputRow(
                      label: "Weight (kg)",
                      controller: controller.weightController,
                      focusNode: controller.weightFocus,
                      textInputAction: TextInputAction.next, // "Next" for Weight
                    ),
                    SizedBox(height: 40 * autoScale),
                    _buildInputRow(
                      label: "Age",
                      controller: controller.ageController,
                      textInputAction: TextInputAction.done, // "Done" for Age
                    ),
                    SizedBox(height: 60 * autoScale),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildBmiResultBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.0 * autoScale, right: 20.0 * autoScale, top: 20.0 * autoScale, bottom: 40.0 * autoScale),
        child: SizedBox(
          height: screenHeight * 0.065,
          width: double.infinity,
          child: Obx(
                () => ElevatedButton(
              onPressed: controller.bmi.value != null
                  ? () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seenIntro', true);
                Get.to(() => const TargetWeightPage(), transition: Transition.noTransition);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: controller.bmi.value != null ? AppColors.pGreenColor : AppColors.pNoColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: ReusableText(
                text: "Next",
                size: 18 * autoScale,
                color: AppColors.pWhiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({
    required String label,
    required TextEditingController controller,
    FocusNode? focusNode,
    required TextInputAction textInputAction,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ReusableText(
            text: label,
            size: 18 * autoScale,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textInputAction: textInputAction, // Set the action here
            cursorColor: AppColors.pBlackColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.pGrey100Color,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.pGreenColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) => this.controller.validateFields(),
          ),
        ),
      ],
    );
  }

  Widget _buildBmiResultBox() {
    final screenWidth = Get.width;

    return Container(
      padding: const EdgeInsets.all(20.0),
      width: screenWidth * 0.85,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: "CURRENT BMI: ",
            size: 24 * autoScale,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Column(
                children: [
                  ReusableText(
                    text: controller.bmi.value?.toStringAsFixed(1) ?? "--",
                    size: 32 * autoScale,
                    color: controller.getBMIResultColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  Obx(() => ReusableText(
                    text: controller.bmiCategory.value.isNotEmpty ? controller.bmiCategory.value : "",
                    size: 12 * autoScale,
                    color: controller.getBMIResultColor(),
                    fontWeight: FontWeight.w500,
                  )),
                ],
              )),
              const SizedBox(width: 20.0),
              Expanded(
                child: Obx(() => ReusableText(
                  text: controller.getBMIMessage(),
                  size: 18 * autoScale,
                  color: AppColors.pDarkGreyColor,
                  fontWeight: FontWeight.normal,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
