// library_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/api/dummy_data.dart';
import 'package:psb_app/model/exercise_model.dart';
import 'package:psb_app/utils/global_variables.dart';

class LibraryController extends GetxController {
  // Observable list for equipment items
  var equipmentList = <Equipment>[].obs;

  // Observable shadow state
  var showShadow = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadEquipmentData();
  }

  // Loads equipment data into the observable list
  void loadEquipmentData() {
    equipmentList.value = EquipmentData.getEquipmentList();
  }

  // Update shadow visibility based on scroll position
  void updateShadow(double scrollPosition) {
    if (scrollPosition > 0 && !showShadow.value) {
      showShadow.value = true;
    } else if (scrollPosition <= 0 && showShadow.value) {
      showShadow.value = false;
    }
  }

  // Method to retrieve color based on equipment category
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Leg Equipment':
        return AppColors.pOrangeColor;
      case 'Chest Equipment':
        return AppColors.pLightBlueColor;
      case 'Back Equipment':
        return AppColors.pLightPurpleColor;
      case 'Hand Weights':
        return AppColors.pLightGreenColor;
      default:
        return AppColors.pLightGreenColor; // Default color if category doesn't match
    }
  }
}
