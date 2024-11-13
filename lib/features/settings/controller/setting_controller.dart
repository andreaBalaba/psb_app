import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:psb_app/utils/global_variables.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<void> signOut() async {
    try {
      // Sign out from Firebase (works for email/password and Google users)
      await _auth.signOut();

      // Sign out from Google if the user is signed in through Google
      await _googleSignIn.signOut();

      // Clear any shared preferences related to the user session if needed.
    } catch (e) {
      throw Exception("Logout failed: ${e.toString()}");
    }
  }
}
