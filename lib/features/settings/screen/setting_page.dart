import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/authentication/screen/login_page.dart';
import 'package:psb_app/features/settings/controller/setting_controller.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController controller = Get.put(SettingsController());

  double get autoScale => Get.width / 400;

  bool isPrivacyExpanded = false;
  bool isEditInfoExpanded = false;
  int selectedGenderIndex = 0;
  double height = 170;

  void _togglePrivacy() {
    setState(() {
      isPrivacyExpanded = !isPrivacyExpanded;
      if (isPrivacyExpanded) {
        isEditInfoExpanded =
            false; // Close Edit Information if Privacy is opened
      }
    });
  }

  void _toggleEditInfo() {
    setState(() {
      isEditInfoExpanded = !isEditInfoExpanded;
      if (isEditInfoExpanded) {
        isPrivacyExpanded =
            false; // Close Privacy if Edit Information is opened
      }
    });
  }

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
        padding: EdgeInsets.symmetric(horizontal: 20.0 * autoScale),
        child: ListView(
          children: [
            const SizedBox(height: 10),

            // Notification Switch
            Obx(() => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildCustomSwitch(
                    label: "Notification",
                    value: controller.isNotificationEnabled.value,
                    onToggle: controller.toggleNotification,
                  ),
                )),
            Divider(thickness: 1 * autoScale, color: AppColors.pBlackColor),

            // Warm up Switch
            Obx(() => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildCustomSwitch(
                    label: "Warm up",
                    value: controller.isWarmUpEnabled.value,
                    onToggle: controller.toggleWarmUp,
                  ),
                )),
            Divider(thickness: 1 * autoScale, color: AppColors.pBlackColor),

            // Stretching Switch
            Obx(() => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildCustomSwitch(
                    label: "Stretching",
                    value: controller.isStretchingEnabled.value,
                    onToggle: controller.toggleStretching,
                  ),
                )),
            Divider(thickness: 1 * autoScale, color: AppColors.pBlackColor),

            // Privacy Dropdown
            ListTile(
              title: ReusableText(
                text: "Privacy",
                size: 20 * autoScale,
                fontWeight: FontWeight.w600,
                color: AppColors.pBlack87Color,
              ),
              trailing: Icon(
                isPrivacyExpanded
                    ? Icons.keyboard_arrow_down_outlined
                    : Icons.arrow_forward_ios,
                size: 18 * autoScale,
                color: AppColors.pGreyColor,
              ),
              onTap: _togglePrivacy,
            ),
            if (isPrivacyExpanded) ...[
              ListTile(
                title: ReusableText(
                  text: "Privacy Policy",
                  size: 18 * autoScale,
                  fontWeight: FontWeight.w400,
                  color: AppColors.pBlack87Color,
                ),
                onTap: () {
                  // Handle Privacy Policy tap
                },
              ),
              ListTile(
                title: ReusableText(
                  text: "Terms and Conditions",
                  size: 18 * autoScale,
                  fontWeight: FontWeight.w400,
                  color: AppColors.pBlack87Color,
                ),
                onTap: () {
                  // Handle Terms and Conditions tap
                },
              ),
            ],
            Divider(thickness: 1 * autoScale, color: AppColors.pBlackColor),

            // Account Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0 * autoScale),
              child: ReusableText(
                text: "Account",
                size: 18 * autoScale,
                fontWeight: FontWeight.w600,
                color: AppColors.pGreyColor,
              ),
            ),

            ListTile(
              title: ReusableText(
                text: "Edit information",
                size: 20 * autoScale,
                fontWeight: FontWeight.w600,
                color: AppColors.pBlack87Color,
              ),
              trailing: Icon(
                isEditInfoExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.arrow_forward_ios,
                size: 18 * autoScale,
                color: AppColors.pGreyColor,
              ),
              onTap: _toggleEditInfo,
            ),
            if (isEditInfoExpanded) ...[
              GestureDetector(
                onTap: _showHeightBottomSheet,
                child: _buildAccountInfo(
                    "Height", "${height.toInt()} cm", AppColors.pOrangeColor),
              ),
              _buildAccountInfo("Weight", "65.0 kg", AppColors.pOrangeColor),
              _buildAccountInfo("Age", "21", AppColors.pOrangeColor),
              _buildGenderSelection(),
            ],
            Divider(thickness: 1 * autoScale, color: AppColors.pBlackColor),

            const SizedBox(height: 60),

            // Log Out Button
            ElevatedButton(
              onPressed: () async {
                bool? shouldLogOut = await Get.dialog<bool>(AlertDialog(
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
                      onPressed: () async {
                        await controller.signOut();
                        Get.back(result: true);
                      },
                      child: ReusableText(
                        text: "Log out",
                        color: AppColors.pSOrangeColor,
                        size: 16 * autoScale,
                      ),
                    ),
                  ],
                ));

                if (shouldLogOut == true) {
                  Get.offAll(const LogInPage());
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

  Widget _buildCustomSwitch({
    required String label,
    required bool value,
    required Function(bool) onToggle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(
          text: label,
          size: 20 * autoScale,
          fontWeight: FontWeight.w600,
        ),
        FlutterSwitch(
          width: 50.0 * autoScale,
          height: 30.0 * autoScale,
          toggleSize: 25.0 * autoScale,
          value: value,
          borderRadius: 20.0 * autoScale,
          padding: 2.0 * autoScale,
          activeColor: AppColors.pGreenColor,
          inactiveColor: AppColors.pMGreyColor,
          onToggle: onToggle,
        ),
      ],
    );
  }

  Widget _buildAccountInfo(String title, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 6 * autoScale, horizontal: 16.0 * autoScale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: title,
            size: 18 * autoScale,
            color: AppColors.pBlack87Color,
            fontWeight: FontWeight.w600,
          ),
          ReusableText(
            text: value,
            size: 18 * autoScale,
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  void _showHeightBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20 * autoScale)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20 * autoScale,
            left: 16 * autoScale,
            right: 16 * autoScale,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildHeightDialogContent(),
        );
      },
    );
  }

  Widget _buildHeightDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReusableText(
          text: "Height",
          fontWeight: FontWeight.bold,
          size: 20 * autoScale,
        ),
        SizedBox(height: 10 * autoScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "cm",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16 * autoScale,
              ),
            ),
            Switch(
              value: true, // This would toggle between cm/ft
              onChanged: (bool value) {},
            ),
            Text(
              "ft",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16 * autoScale,
              ),
            ),
          ],
        ),
        SizedBox(height: 10 * autoScale),
        Text(
          "${height.toInt()} cm",
          style: TextStyle(
            fontSize: 40 * autoScale,
            color: AppColors.pOrangeColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: height,
          min: 100,
          max: 230,
          divisions: 130,
          label: "${height.toInt()}",
          onChanged: (value) {
            setState(() {
              height = value;
            });
          },
        ),
        SizedBox(height: 20 * autoScale),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pSOrangeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10 * autoScale),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 30.0 * autoScale, vertical: 12 * autoScale),
            child: ReusableText(
              text: 'Save',
              size: 18 * autoScale,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10 * autoScale),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 6 * autoScale, horizontal: 16.0 * autoScale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: "Gender",
            size: 18 * autoScale,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          SizedBox(height: 10 * autoScale),
          FlutterToggleTab(
            width: 40 * autoScale,
            borderRadius: 5 * autoScale,
            height: 30 * autoScale,
            selectedIndex: selectedGenderIndex,
            selectedBackgroundColors: const [AppColors.pOrangeColor],
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
            labels: const ["Male", "Female"],
            selectedLabelIndex: (index) {
              setState(() {
                selectedGenderIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
