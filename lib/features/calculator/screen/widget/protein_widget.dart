import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ProteinWidget extends StatelessWidget {
  const ProteinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final RxDouble weight = 0.0.obs;

    double screenWidth = Get.width;
    double autoScale = screenWidth / 400;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.35,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        weight.value = double.tryParse(value) ?? 0.0;
                      },
                      decoration: InputDecoration(
                        hintText: 'Weight',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0,
                        ),
                        filled: true,
                        fillColor: AppColors.pWhiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: AppColors.pGreyColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ReusableText( text: "kg", size: 18 * autoScale),
                  const SizedBox(width: 10),
                  ReusableText(
                    text: "÷ 0.8g",
                    fontWeight: FontWeight.bold,
                    size: 28 * autoScale,
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Container(
                padding: const EdgeInsets.all(20.0),
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.pPurpleColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    ReusableText(
                      text: 'Total protein intake',
                      size: 24 * autoScale,
                      color: AppColors.pWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    Obx(() => ReusableText(
                      text: '${(weight.value * 0.8).toInt()}g', // Display protein intake
                      size: 36 * autoScale,
                      color: AppColors.pWhiteColor,
                      fontWeight: FontWeight.bold,
                    )),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          ImageAssets.pDYTPic,
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                        ),
                        const SizedBox(width: 10),
                        ReusableText(
                          text: 'Did you know that?',
                          fontWeight: FontWeight.w600,
                          size: 18 * autoScale,
                          color: AppColors.pWhiteColor,
                        ),
                      ],
                    ),
                    ReusableText(
                      text: 'For adults: The RDA for adults is\n approximately 0.8 grams of protein per Kg of body weight. '
                          'To calculate this, divide your weight in kilograms by 0.8. '
                          'For example, a person weighing 68 kilograms would need about 54 grams of protein per day (68 kg ÷ 0.8 = 54 g).',
                      color: AppColors.pWhiteColor,
                      size: 14 * autoScale,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
