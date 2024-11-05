import 'package:get/get.dart';
import 'package:psb_app/utils/global_variables.dart';

class SettingsController extends GetxController {
  final RxBool isNotificationEnabled = false.obs;
  final RxBool isWarmUpEnabled = false.obs;
  final RxBool isStretchingEnabled = false.obs;
  final RxString selectedGender = 'Male'.obs; // For gender selection

  // Toggle methods for each setting
  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
    Get.snackbar(
      'Settings',
      'Notifications ${value ? 'enabled' : 'disabled'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.pMGreyColor,
    );
  }

  void toggleWarmUp(bool value) {
    isWarmUpEnabled.value = value;
    Get.snackbar(
      'Settings',
      'Warm up ${value ? 'enabled' : 'disabled'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.pMGreyColor,
    );
  }

  void toggleStretching(bool value) {
    isStretchingEnabled.value = value;
    Get.snackbar(
      'Settings',
      'Stretching ${value ? 'enabled' : 'disabled'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.pMGreyColor,
    );
  }

  // Method to select gender
  void selectGender(String gender) {
    selectedGender.value = gender;
    Get.snackbar(
      'Settings',
      'Gender set to $gender',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.pMGreyColor,
    );
  }
}
