import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/authentication/screen/login_page.dart';
import 'package:psb_app/features/settings/controller/setting_controller.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsController controller = Get.put(SettingsController());

  double get autoScale => Get.width / 400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        title: ReusableText(
          text: 'Settings',
          size: 30 * autoScale,
          fontWeight: FontWeight.w500,
          color: AppColors.pGrey800Color,
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: ReusableText(
              text: 'Back',
              size: 18 * autoScale,
              color: AppColors.pGrey800Color,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0 * autoScale),
        child: Column(
          children: [
            Obx(() => SwitchListTile(
              title: ReusableText(
                text: "Notifications",
                size: 18 * autoScale,
                fontWeight: FontWeight.w500,
                color: AppColors.pBlack87Color,
              ),
              value: controller.isToggled.value,
              onChanged: controller.toggleNotifications,
              activeColor: AppColors.pSOrangeColor,
              activeTrackColor: AppColors.pMGreyColor,
              inactiveThumbColor: AppColors.pSOrangeColor,
              inactiveTrackColor: AppColors.pMGreyColor,
              visualDensity: VisualDensity.compact,
            )),
            Divider(thickness: 1 * autoScale),
            SizedBox(height: 20 * autoScale),
            ElevatedButton(
              onPressed: () async {
                bool? shouldLogOut = await Get.dialog<bool>(
                  AlertDialog(
                    backgroundColor: AppColors.pBGWhiteColor,
                    title: ReusableText(
                      text: "Confirmation",
                      size: 18 * autoScale,
                      fontWeight: FontWeight.bold,
                    ),
                    content: ReusableText(
                      text: "Are you sure you want to log out?",
                      size: 16 * autoScale,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: ReusableText(
                          text: "Cancel",
                          color: AppColors.pSOrangeColor,
                          size: 16 * autoScale,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: ReusableText(
                          text: "Log out",
                          color: AppColors.pSOrangeColor,
                          size: 16 * autoScale,
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldLogOut == true) {
                  Get.offAll(const LogInPage());
                  //await controller.logOut();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pSOrangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10 * autoScale),
                ),
              ),
              child: ReusableText(
                text: 'Log out',
                size: 18 * autoScale,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
