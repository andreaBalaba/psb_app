import 'package:get/get.dart';
import 'package:psb_app/utils/global_variables.dart';

class SettingsController extends GetxController {
  final RxBool isToggled = false.obs;

  void toggleNotifications(bool value) {
    isToggled.value = value;
    Get.snackbar('Settings', 'Notifications ${value ? 'enabled' : 'disabled'}',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: AppColors.pMGreyColor);
  }

}
