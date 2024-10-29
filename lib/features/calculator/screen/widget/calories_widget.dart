import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/calculator/controller/side_calculator_controller.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class CaloriesWidget extends StatelessWidget {
  const CaloriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CalculatorController calculatorController = Get.put(CalculatorController());
    double screenWidth = Get.width;
    double autoScale = screenWidth / 400;

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
                      controller: calculatorController.CalweightController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        calculatorController.weight.value = double.tryParse(value) ?? 0.0;
                      },
                      decoration: InputDecoration(
                        hintText: 'Weight',
                        filled: true,
                        fillColor: AppColors.pWhiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ReusableText(text: "kg", size: 16 * autoScale),
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
                      controller: calculatorController.CalheightController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        calculatorController.height.value = double.tryParse(value) ?? 0.0;
                      },
                      decoration: InputDecoration(
                        hintText: 'Height',
                        filled: true,
                        fillColor: AppColors.pWhiteColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ReusableText(text: "cm", size: 16 * autoScale),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
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
                          // Clear inputs in the controller
                          calculatorController.clearCaloriesInputs();
                          // Also clear the TextEditingControllers
                          calculatorController.CalageController.clear();
                          calculatorController.CalweightController.clear();
                          calculatorController.CalheightController.clear();
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
}
