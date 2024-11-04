import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:psb_app/api/dummy_data.dart';
import 'package:psb_app/model/exercise_model.dart';
import 'package:psb_app/utils/global_variables.dart';

class LibraryController extends GetxController {
  var equipmentList = <Equipment>[].obs; // Observable for the equipment list
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadEquipmentData();
    // No shadow logic in the controller, just data loading and scroll management
  }

  void loadEquipmentData() {
    equipmentList.value = EquipmentData.getEquipmentList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

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
        return AppColors.pLightGreenColor;
    }
  }
}
