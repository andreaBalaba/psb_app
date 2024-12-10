import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/calculator/controller/side_calculator_controller.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart'; // Ensure this import is included

class BmiWidget extends StatefulWidget {
  const BmiWidget({super.key});

  @override
  State<BmiWidget> createState() => _BmiWidgetState();
}

class _BmiWidgetState extends State<BmiWidget> {
  final CalculatorController calculatorController = Get.put(CalculatorController());
  double autoScale = Get.width / 400;
  bool isKgInput = true; // Track whether the input is in kg or lbs
  bool isCmInput = true;


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: TextField(
                      controller: calculatorController.ageController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        calculatorController.age.value = int.tryParse(value) ?? 0;
                        calculatorController.calculateBMI();
                      },
                      decoration: InputDecoration(
                        hintText: 'Age',
                        filled: true,
                        fillColor: AppColors.pWhiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  ReusableText(text: "y/o", size: 16 * autoScale),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(() => Radio<String>(
                            value: 'Male',
                            groupValue: calculatorController.gender.value,
                            onChanged: (String? value) {
                              calculatorController.gender.value = value ?? "Male";
                              calculatorController.calculateBMI();
                            },
                          )),
                          ReusableText(text: 'Male', fontWeight: FontWeight.w500, size: 16 * autoScale),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() => Radio<String>(
                            value: 'Female',
                            groupValue: calculatorController.gender.value,
                            onChanged: (String? value) {
                              calculatorController.gender.value = value ?? "Male";
                              calculatorController.calculateBMI();
                            },
                          )),
                          ReusableText(text: 'Female', fontWeight: FontWeight.w500, size: 16 * autoScale),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: TextField(
                        controller: TextEditingController(
                          text: isKgInput
                              ? (calculatorController.weightKg.value != 0
                              ? calculatorController.weightKg.value.toStringAsFixed(1)
                              : '')
                              : (calculatorController.weightLbs.value != 0
                              ? calculatorController.weightLbs.value.toStringAsFixed(1)
                              : ''),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            // Treat empty input as null
                            calculatorController.weightKg.value = 0.0;
                            calculatorController.weightLbs.value = 0.0;
                          } else {
                            double parsedValue = double.tryParse(value) ?? 0.0;
                            calculatorController.updateWeight(parsedValue, isKgInput);
                          }
                          calculatorController.calculateBMI();
                        },
                        decoration: InputDecoration(
                          hintText: isKgInput ? 'Weight (kg)' : 'Weight (lbs)',
                          filled: true,
                          fillColor: AppColors.pWhiteColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                  ),
                  _buildWeightUnitToggle() // Add the toggle here
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: TextField(
                        controller: TextEditingController(
                          text: isCmInput
                              ? (calculatorController.height.value != 0
                              ? calculatorController.height.value.toStringAsFixed(1)
                              : '')
                              : (calculatorController.height.value != 0
                              ? (calculatorController.height.value / 30.48).toStringAsFixed(1)
                              : ''),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            // Treat empty input as null
                            calculatorController.height.value = 0.0;
                          } else {
                            double parsedValue = double.tryParse(value) ?? 0.0;
                            if (isCmInput) {
                              calculatorController.height.value = parsedValue; // in cm
                            } else {
                              calculatorController.height.value = parsedValue * 30.48; // Convert ft to cm
                            }
                          }
                          calculatorController.calculateBMI();
                        },
                        decoration: InputDecoration(
                          hintText: isCmInput ? 'Height (cm)' : '(ft) eg. 5.1',
                          filled: true,
                          fillColor: AppColors.pWhiteColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  _buildHeightUnitToggle() // Add the toggle here
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: screenWidth * 0.9,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.pPurpleColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: "Result:",
                        fontWeight: FontWeight.bold,
                        size: 24 * autoScale,
                        color: AppColors.pWhiteColor,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            calculatorController.clearBMIInputs();
                            calculatorController.ageController.clear();
                            calculatorController.weightKg.value = 0.0;
                            calculatorController.weightLbs.value = 0.0;
                            calculatorController.height.value = 0.0;
                            isKgInput = true;
                            isCmInput = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pBGWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: ReusableText(
                          text: "Clear",
                          color: AppColors.pPurpleColor,
                          fontWeight: FontWeight.bold,
                          size: 14 * autoScale,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Obx(() {
                      String resultText = calculatorController.bmiCategory.value.isNotEmpty
                          ? "Your BMI: ${calculatorController.bmi.value.toStringAsFixed(1)}\nClassification: ${calculatorController.bmiCategory.value}"
                          : "Enter details to calculate BMI.";
                      return ReusableText(
                        text: resultText,
                        color: AppColors.pWhiteColor,
                        fontWeight: FontWeight.w600,
                        size: 18 * autoScale,
                        align: TextAlign.center,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Weight unit toggle button
  Widget _buildWeightUnitToggle() {
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
            double currentWeight = isKgInput
                ? calculatorController.weightKg.value
                : calculatorController.weightLbs.value;
            // Update the weight based on the selected unit
            calculatorController.updateWeight(currentWeight, isKgInput);
            calculatorController.calculateBMI();
          });
        },
      ),
    );
  }

  Widget _buildHeightUnitToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6 * autoScale, horizontal: 16.0 * autoScale),
      child: FlutterToggleTab(
        width: 40 * autoScale,
        borderRadius: 20 * autoScale,
        height: 30 * autoScale,
        selectedIndex: isCmInput ? 0 : 1,
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
        labels: const ["cm", "ft"],
        selectedLabelIndex: (index) {
          setState(() {
            isCmInput = (index == 0);
            double currentHeight = isCmInput
                ? calculatorController.height.value
                : calculatorController.height.value / 30.48; // Convert cm to ft
            // Update the height based on the selected unit
            calculatorController.height.value = isCmInput ? currentHeight : currentHeight * 30.48;
            calculatorController.calculateBMI();
          });
        },
      ),
    );
  }
}
