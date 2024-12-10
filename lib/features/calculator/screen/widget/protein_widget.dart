import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart'; // Make sure this import is added

class ProteinWidget extends StatefulWidget {
  const ProteinWidget({super.key});

  @override
  State<ProteinWidget> createState() => _ProteinWidgetState();
}

class _ProteinWidgetState extends State<ProteinWidget> {
  double weightKg = 0.0; // Store weight in kg
  double weightLbs = 0.0; // Store weight in lbs
  bool isKgInput = true; // Track whether the input is in kg or lbs
  double autoScale = Get.width / 400;

  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    width: Get.width * 0.35,
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            weightKg = 0.0;
                            weightLbs = 0.0;
                          } else {
                            double parsedValue = double.tryParse(value) ?? 0.0;
                            if (isKgInput) {
                              weightKg = parsedValue;
                              weightLbs = parsedValue * 2.20462;
                            } else {
                              weightLbs = parsedValue;
                              weightKg = parsedValue / 2.20462;
                            }
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: isKgInput ? 'Weight (kg)' : 'Weight (lbs)',
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
                  _buildUnitToggle(),
                ],
              ),
              const SizedBox(height: 20),
              ReusableText(
                text: "x",
                fontWeight: FontWeight.bold,
                size: 32 * autoScale,
              ),
              const SizedBox(height: 20),
              ReusableText(
                text: "0.8g",
                fontWeight: FontWeight.bold,
                size: 28 * autoScale,
              ),
              const SizedBox(height: 40.0),
              Container(
                padding: const EdgeInsets.all(20.0),
                width: Get.width * 0.9,
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
                    ReusableText(
                      text: '${(weightKg * 0.8).toInt()}g',
                      size: 36 * autoScale,
                      color: AppColors.pWhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          ImageAssets.pDYTPic,
                          width: Get.width * 0.2,
                          height: Get.width * 0.2,
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
                          'For example, a person weighing 68 kilograms would need about 54 grams of protein per day (68 kg x 0.8 = 54 g).',
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

  // Weight unit toggle button
  Widget _buildUnitToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6 * autoScale, horizontal: 16.0 * autoScale),
      child: FlutterToggleTab(
        width: 40 * autoScale,
        borderRadius: 20 * autoScale,
        height: 30 * autoScale,
        selectedIndex: isKgInput ? 0 : 1,
        selectedBackgroundColors: const [AppColors.pPurpleColor],
        selectedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16 * autoScale,
          fontWeight: FontWeight.w500,
        ),
        unSelectedTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16 * autoScale,
          fontWeight: FontWeight.w400,
        ),
        labels: const ["kg", "lbs"],
        selectedLabelIndex: (index) {
          setState(() {
            isKgInput = (index == 0);
            _weightController.text = isKgInput
                ? (weightKg == 0.0 ? '' : weightKg.toStringAsFixed(1))
                : (weightLbs == 0.0 ? '' : weightLbs.toStringAsFixed(1));
          });
        },
      ),
    );
  }
}
