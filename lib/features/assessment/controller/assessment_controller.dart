import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssessmentController extends GetxController {
  // Observable variables for selections
  var selectedMotivationIndex = (-1).obs;
  var selectedGoalIndex = (-1).obs;
  var selectedFocusAreaIndex = (-1).obs;
  var selectedAnyEventsIndex = (-1).obs;
  var selectedIdentifySexIndex = (-1).obs;
  var selectedBodyShape = ''.obs;
  var selectedActivityLevel = ''.obs;
  var selectedFlexibilityLevel = ''.obs;
  var selectedAerobicLevel = ''.obs;
  var selectedFitnessLevel = ''.obs;
  var selectedStopGoalIndex = (-1).obs;
  var selectedWhereYouWorkoutIndex = (-1).obs;
  var selectedAnyDiscomfortIndex = (-1).obs;


  var bmi = RxnDouble(null);
  var bmiCategory = ''.obs;
  var isLoading = false.obs;
  var isButtonEnabled = false.obs;
  var gender = 'Male'.obs; // Default gender
  var inputMessage = ''.obs;

  var targetWeight = 70.obs; // Default target weight
  var weightChangeHeader = ''.obs; // Header for the assessment (e.g., GOOD CHOICE)
  var weightChangeSemiHeader = ''.obs; // Semi-header with weight change percentage
  var weightChangeMessage = ''.obs; // Detailed message for target weight assessment

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final FocusNode heightFocus = FocusNode();
  final FocusNode weightFocus = FocusNode();
  final FocusNode ageFocus = FocusNode();

  // Methods for updating selections
  void setSelectedMotivationIndex(int index) {
    selectedMotivationIndex.value = index;
  }

  void setSelectedGoalIndex(int index) {
    selectedGoalIndex.value = index;
  }

  void setSelectedFocusAreaIndex(int index) {
    selectedFocusAreaIndex.value = index;
  }

  void setSelectedAnyEventsIndex(int index) {
    selectedAnyEventsIndex.value = index;
  }

  void setSelectedIdentifySexIndex(int index) {
    selectedIdentifySexIndex.value = index;
  }

  void setSelectedStopGoalIndex(int index) {
    selectedStopGoalIndex.value = index;
  }

  void setSelectedWhereYouWorkoutIndex(int index) {
    selectedWhereYouWorkoutIndex.value = index;
  }

  void setSelectedAnyDiscomfortIndex(int index) {
    selectedAnyDiscomfortIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    loadGenderPreference();

    // Listen to input field changes to reset BMI instantly if any field is cleared
    heightController.addListener(_onInputFieldChanged);
    weightController.addListener(_onInputFieldChanged);
    ageController.addListener(_onInputFieldChanged);
  }

  Future<void> loadGenderPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    gender.value = prefs.getString('selectedGender') ?? 'Male';
  }

  void setGender(int index) {
    gender.value = index == 0 ? "Male" : "Female";
    validateFields();
  }

  void validateFields() {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);
    int? age = int.tryParse(ageController.text);

    if (height == null || height <= 0) {
      inputMessage.value = "Please input your height";
      resetBMI();
    } else if (weight == null || weight <= 0) {
      inputMessage.value = "Please input your weight";
      resetBMI();
    } else if (age == null || age <= 0) {
      inputMessage.value = "Please input your age";
      resetBMI();
    } else {
      inputMessage.value = "";
      isButtonEnabled.value = true;
      calculateBMI();
    }
  }

  void resetBMI() {
    bmi.value = null;
    bmiCategory.value = "";
    weightChangeHeader.value = ""; // Reset target weight header
    weightChangeSemiHeader.value = ""; // Reset target weight semi-header
    weightChangeMessage.value = ""; // Reset target weight assessment message
  }

  void calculateBMI() async {
    double? height = double.tryParse(heightController.text);
    double? weight = double.tryParse(weightController.text);
    int? age = int.tryParse(ageController.text);

    if (height == null || weight == null || age == null) {
      resetBMI();
      inputMessage.value = "Please fill out all fields to calculate BMI.";
      isButtonEnabled.value = false;
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500)); // Short delay for better UX

    double heightInMeters = height / 100;
    bmi.value = weight / (heightInMeters * heightInMeters);
    bmiCategory.value = getBMIClassification(bmi.value!, age, gender.value);

    inputMessage.value = "";
    isLoading.value = false;

    // Calculate weight change feedback based on target weight
    calculateWeightChangeFeedback();
  }

  String getBMIClassification(double bmi, int age, String gender) {
    if (age >= 18) {
      if (gender == "Male") {
        if (bmi < 18.5) return "Underweight";
        if (bmi < 24.9) return "Normal weight";
        if (bmi < 29.9) return "Overweight";
        return "Obese";
      } else {
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

  Color getBMIResultColor() {
    switch (bmiCategory.value) {
      case "Normal weight":
        return Colors.green;
      case "Overweight":
        return Colors.yellow[600]!;
      case "Obese":
      case "Underweight":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  String getBMIMessage() {
    switch (bmiCategory.value) {
      case "Normal weight":
        return "You've got a great figure! Keep it up!";
      case "Overweight":
        return "Let's aim for a healthier weight!";
      case "Obese":
        return "Consider a health plan for better results.";
      case "Underweight":
        return "You're a bit underweight. Take care!";
      default:
        return "Please enter your height, weight, and age to calculate BMI.";
    }
  }

  // Listener method to reset BMI instantly when any input field is cleared
  void _onInputFieldChanged() {
    if (heightController.text.isEmpty || weightController.text.isEmpty || ageController.text.isEmpty) {
      resetBMI();
      inputMessage.value = "Please fill out all fields to calculate BMI.";
      isButtonEnabled.value = false;
    } else {
      validateFields();
    }
  }

  void calculateWeightChangeFeedback() {
    double? currentWeight = double.tryParse(weightController.text);
    if (currentWeight == null) return;

    double heightInMeters = (double.tryParse(heightController.text) ?? 0) / 100;
    double targetBmi = targetWeight.value / (heightInMeters * heightInMeters);
    double weightChangePercent = ((targetWeight.value - currentWeight) / currentWeight * 100).abs();

    // Calculate BMI classification based on the target weight
    String bmiClassification = getBMIClassification(targetBmi, int.tryParse(ageController.text) ?? 18, gender.value);

    // Determine if the goal is to gain, maintain, or lose weight
    String goal = targetWeight.value > currentWeight
        ? "gain"
        : (targetWeight.value < currentWeight ? "lose" : "maintain");
    String gainOrLossText = goal == "gain"
        ? "You will gain ${weightChangePercent.toStringAsFixed(1)}% of body weight"
        : goal == "lose"
        ? "You will lose ${weightChangePercent.toStringAsFixed(1)}% of body weight"
        : "Maintain your current weight for optimal health";

    // Feedback structure based on BMI classification, target BMI range, and goal
    if (bmiClassification == "Underweight") {
      weightChangeHeader.value = goal == "gain" ? "GOOD CHOICE!" : "CAUTION!";
      weightChangeSemiHeader.value = gainOrLossText;

      if (goal == "gain") {
        weightChangeMessage.value = "Gaining weight can lead to:\n"
            "- Increased energy and stamina\n"
            "- Improved mood and resilience";
      } else if (goal == "maintain") {
        weightChangeMessage.value = "Maintaining an underweight range may:\n"
            "- Affect muscle strength\n"
            "- Reduce energy and immunity";
      } else {
        weightChangeMessage.value = "Losing weight at this range could:\n"
            "- Further reduce muscle mass\n"
            "- Negatively impact health";
      }

    } else if (bmiClassification == "Normal weight") {
      weightChangeHeader.value = "GREAT CHOICE!";
      weightChangeSemiHeader.value = gainOrLossText;

      if (goal == "gain") {
        weightChangeMessage.value = "A slight weight gain can:\n"
            "- Build muscle and endurance\n"
            "- Enhance physical strength";
      } else if (goal == "maintain") {
        weightChangeMessage.value = "Maintaining this range supports:\n"
            "- Strong energy levels\n"
            "- Balanced metabolism";
      } else {
        weightChangeMessage.value = "Losing weight in this range might:\n"
            "- Not be necessary for health\n"
            "- Reduce energy and stamina";
      }

    } else if (bmiClassification == "Overweight") {
      weightChangeHeader.value = goal == "lose" ? "GOOD CHOICE!" : "CAUTION!";
      weightChangeSemiHeader.value = gainOrLossText;

      if (goal == "gain") {
        weightChangeMessage.value = "Gaining weight may:\n"
            "- Increase strain on joints\n"
            "- Raise health risks over time";
      } else if (goal == "maintain") {
        weightChangeMessage.value = "Maintaining this range may:\n"
            "- Keep existing health risks\n"
            "- Impact energy and endurance";
      } else {
        weightChangeMessage.value = "Losing weight can improve:\n"
            "- Joint health and mobility\n"
            "- Overall energy and well-being";
      }

    } else { // Obese classification
      weightChangeHeader.value = goal == "lose" ? "HIGH PRIORITY!" : "HIGH RISK!";
      weightChangeSemiHeader.value = gainOrLossText;

      if (goal == "gain") {
        weightChangeMessage.value = "Gaining more weight could:\n"
            "- Significantly raise health risks\n"
            "- Impact quality of life";
      } else if (goal == "maintain") {
        weightChangeMessage.value = "Maintaining this weight could:\n"
            "- Increase risk for chronic conditions\n"
            "- Affect mobility and breathing";
      } else {
        weightChangeMessage.value = "Losing weight may help prevent:\n"
            "- Heart disease and diabetes\n"
            "- Breathing and mobility issues";
      }
    }
  }
}
