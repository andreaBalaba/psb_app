import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/calculator/controller/side_calculator_controller.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class CaloriesWidget extends StatefulWidget {
  const CaloriesWidget({super.key});

  @override
  State<CaloriesWidget> createState() => _CaloriesWidgetState();
}

class _CaloriesWidgetState extends State<CaloriesWidget> {
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
            // Age Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: TextField(
                      controller: calculatorController.CalageController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        calculatorController.age.value = int.tryParse(value) ?? 0;
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
                  // Gender Input
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
                            },
                          )),
                          ReusableText(
                            text: 'Male',
                            fontWeight: FontWeight.w500,
                            size: 16 * autoScale,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() => Radio<String>(
                            value: 'Female',
                            groupValue: calculatorController.gender.value,
                            onChanged: (String? value) {
                              calculatorController.gender.value = value ?? "Female";
                            },
                          )),
                          ReusableText(
                            text: 'Female',
                            fontWeight: FontWeight.w500,
                            size: 16 * autoScale,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Weight Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          calculatorController.calweight.value = 0.0;
                        } else {
                          double parsedValue = double.tryParse(value) ?? 0.0;
                          if (isKgInput) {
                            calculatorController.calweight.value = parsedValue;
                          } else {
                            calculatorController.calweight.value = parsedValue / 2.20462;
                          }
                        }
                      },
                      controller: TextEditingController(
                        text: isKgInput
                            ? (calculatorController.calweight.value == 0.0
                            ? ''
                            : calculatorController.calweight.value.toStringAsFixed(1))
                            : ((calculatorController.calweight.value * 2.20462) == 0.0
                            ? ''
                            : (calculatorController.calweight.value * 2.20462).toStringAsFixed(1)),
                      ),
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
                  const SizedBox(width: 14),
                  _buildWeightUnitToggle(),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            // Height Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          calculatorController.calheight.value = 0.0;
                        } else {
                          double parsedValue = double.tryParse(value) ?? 0.0;
                          if (isCmInput) {
                            calculatorController.calheight.value = parsedValue;
                          } else {
                            calculatorController.calheight.value = parsedValue * 30.48;
                          }
                        }
                      },
                      controller: TextEditingController(
                        text: isCmInput
                            ? (calculatorController.calheight.value == 0.0
                            ? ''
                            : calculatorController.calheight.value.toStringAsFixed(1))
                            : ((calculatorController.calheight.value / 30.48) == 0.0
                            ? ''
                            : (calculatorController.calheight.value / 30.48).toStringAsFixed(1)),
                      ),
                      decoration: InputDecoration(
                        hintText: isCmInput ? 'Height (cm)' : 'Height (ft)',
                        filled: true,
                        fillColor: AppColors.pWhiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  _buildHeightUnitToggle(),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            // Activity Dropdown and Result
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: screenWidth * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: AppColors.pPurpleColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Obx(() => DropdownButton<String>(
                  value: calculatorController.dropdownValue.value,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  iconSize: 24,
                  dropdownColor: AppColors.pPurpleColor,
                  underline: const SizedBox(height: 1.0),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    calculatorController.dropdownValue.value = newValue ?? 'Activity';
                  },
                  items: <String>[
                    'Activity',
                    'Basal Metabolic Rate (BMR)',
                    'Sedentary: little or no exercise',
                    'Light: exercise 1-3 times/week',
                    'Moderate: exercise 4-5 times/week',
                    'Active: daily exercise or intense 3-4 times/week',
                    'Very Active: intense exercise 6-7 times/week',
                    'Extra Active: very intense exercise daily, or physical job',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                )),
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
                            calculatorController.clearCaloriesInputs();
                            calculatorController.CalageController.clear();
                            calculatorController.calweight.value = 0.0;
                            calculatorController.calheight.value = 0.0;
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
                      String resultText = (calculatorController.calculateCalories() == null || calculatorController.dropdownValue.value == 'Activity')
                          ? "Enter details to calculate calories."
                          : "Your daily calories requirement: ${calculatorController.calculateCalories()!.toStringAsFixed(0)} kcal";
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

  Widget _buildWeightUnitToggle() {
    return FlutterToggleTab(
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
          isKgInput = index == 0;
        });
      },
    );
  }

  Widget _buildHeightUnitToggle() {
    return FlutterToggleTab(
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
          isCmInput = index == 0;
        });
      },
    );
  }
}
