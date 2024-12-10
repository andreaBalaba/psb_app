import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalculatorController extends GetxController {
  // Observables
  var calweight = 0.0.obs;
  var calheight = 0.0.obs;
  var weightKg = 0.0.obs;  // Weight in kg
  var weightLbs = 0.0.obs; // Weight in lbs
  var height = 0.0.obs;
  var age = 0.obs;
  var gender = 'Male'.obs; // Default gender selection
  var bmi = 0.0.obs;
  var bmiCategory = ''.obs;
  var dropdownValue = 'Activity'.obs; // Default dropdown value
  var caloriesResultText = "Enter details to calculate calories.".obs;

  TextEditingController ageController = TextEditingController();
  //TextEditingController weightController = TextEditingController();
  //TextEditingController heightController = TextEditingController();
  TextEditingController CalageController = TextEditingController();
  //TextEditingController CalweightController = TextEditingController();
  //TextEditingController CalheightController = TextEditingController();



  // Method to calculate BMI
  void calculateBMI() {
    if (areBMInputsValid()) {
      double heightInMeters = height.value / 100;
      bmi.value = weightKg.value / (heightInMeters * heightInMeters); // Use weight in kg for BMI calculation
      bmiCategory.value = getBMIClassification(bmi.value, age.value, gender.value);
    } else {
      bmi.value = 0.0;
      bmiCategory.value = '';
    }
  }

  // Method to classify BMI
  String getBMIClassification(double bmi, int age, String gender) {
    if (age >= 18) {
      if (gender == "Male") {
        if (bmi < 18.5) return "Underweight";
        if (bmi < 24.9) return "Normal weight";
        if (bmi < 29.9) return "Overweight";
        return "Obese";
      } else { // Female classification
        if (bmi < 18.0) return "Underweight";
        if (bmi < 24.0) return "Normal weight";
        if (bmi < 29.0) return "Overweight";
        return "Obese";
      }
    } else if (age >= 13 && age < 18) {
      if (bmi < 16.5) return "Underweight";
      if (bmi < 23.0) return "Normal weight";
      if (bmi < 27.0) return "Overweight";
      return "Obese";
    } else {
      if (bmi < 15.0) return "Underweight";
      if (bmi < 22.0) return "Normal weight";
      if (bmi < 26.0) return "Overweight";
      return "Obese";
    }
  }

  // Method to calculate calories
  double? calculateCalories() {
    if (dropdownValue.value == 'Activity' || !areInputsValid()) {
      caloriesResultText.value = "Enter details to calculate calories."; // Reset result text
      return null; // Return null to indicate no calculation
    }

    // Proceed with calorie calculation if inputs are valid
    if (calheight.value > 0 && calweight.value > 0 && age.value > 0) {
      double bmr;
      if (gender.value == "Male") {
        bmr = 88.362 + (13.397 * calweight.value) + (4.799 * calheight.value) - (5.677 * age.value);
      } else {
        bmr = 447.593 + (9.247 * calweight.value) + (3.098 * calheight.value) - (4.330 * age.value);
      }

      double calorieMultiplier = getCalorieMultiplier();
      double calories = bmr * calorieMultiplier;
      caloriesResultText.value = "Your daily calorie requirement: ${calories.toStringAsFixed(0)} kcal"; // Set result text
      return calories;
    }
    return null;
  }

  // Method to check if inputs are valid
  bool areInputsValid() {
    return calweight.value > 0 && calheight.value > 0 && age.value > 0;
  }

  bool areBMInputsValid() {
    return weightKg.value > 0 && height.value > 0 && age.value > 0;
  }

  // Method to get calorie multiplier based on activity level
  double getCalorieMultiplier() {
    switch (dropdownValue.value) {
      case 'Sedentary: little or no exercise':
        return 1.2;
      case 'Light: exercise 1-3 times/week':
        return 1.375;
      case 'Moderate: exercise 4-5 times/week':
        return 1.55;
      case 'Active: daily exercise or intense 3-4 times/week':
        return 1.725;
      case 'Very Active: intense exercise 6-7 times/week':
        return 1.9;
      case 'Extra Active: very intense exercise daily, or physical job':
        return 2.0;
      default:
        return 1.0; // Basal Metabolic Rate (BMR) only
    }
  }

  // Function to clear BMI inputs and results
  void clearBMIInputs() {
    height.value = 0.0;
    weightKg.value = 0.0;  // Clear kg weight
    weightLbs.value = 0.0; // Clear lbs weight
    age.value = 0;
    bmi.value = 0.0;
    bmiCategory.value = '';
    ageController.clear(); // Clear controller text
    //weightController.clear(); // Clear controller text
   // heightController.clear(); // Clear controller text
  }

  // Function to clear Calories inputs and results
  void clearCaloriesInputs() {
    calheight.value = 0.0;
    calweight.value = 0.0;
    age.value = 0;
    dropdownValue.value = 'Activity'; // Reset to default dropdown value
    caloriesResultText.value = "Enter details to calculate calories."; // Reset result text
    CalageController.clear();
    //CalweightController.clear();
    //CalheightController.clear();
  }

  void updateWeight(double weight, bool isKgInput) {
    if (isKgInput) {
      weightKg.value = weight;
      weightLbs.value = weight * 2.20462; // Conversion from kg to lbs
    } else {
      weightLbs.value = weight;
      weightKg.value = weight / 2.20462; // Conversion from lbs to kg
    }
    calculateBMI();
  }

}
