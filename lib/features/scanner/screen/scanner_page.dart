import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/scanner/controller/scanner_controller.dart';
import 'package:psb_app/features/scanner/screen/widget/camera_widget.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  final ScannerController controller = Get.put(ScannerController());
  String selectedLevel = "Beginner"; // Default level
  final List<String> levels = ["Beginner", "Intermediate", "Experienced"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.startImageStream();
  }

  @override
  void dispose() {
    // Stop image stream and remove observer if still active
    if (controller.isCameraInitialized.value) {
      controller.stopImageStream();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Restart the image stream when returning to the app if the camera is initialized
      if (controller.isCameraInitialized.value) {
        controller.startImageStream();
      }
    } else if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Stop the image stream when the app goes to background
      if (controller.isCameraInitialized.value) {
        controller.stopImageStream();
      }
    }
  }

  void showLevelSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double autoScale = Get.width / 400;

        return Dialog(
          backgroundColor: AppColors.pBGWhiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20 * autoScale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: levels.map((level) {
                return ListTile(
                  title: Center(
                    child: ReusableText(
                      text: level,
                      size: 18 * autoScale,
                      fontWeight: FontWeight.bold,
                      color: level == selectedLevel
                          ? AppColors.pGreenColor
                          : AppColors.pBlackColor,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedLevel = level;
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 400;

    return Scaffold(
      backgroundColor: AppColors.pBGGreyColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGGreyColor,
        elevation: 0,
        toolbarHeight: 80 * autoScale,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.pBlackColor),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 20.0 * autoScale),
          child: InkWell(
            onTap: showLevelSelectionDialog,
            child: Column(
              children: [
                Icon(Icons.arrow_drop_up, color: AppColors.pBlackColor),
                ReusableText(
                  text: selectedLevel,
                  size: 18 * autoScale,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.center,
                ),
                Icon(Icons.arrow_drop_down, color: AppColors.pBlackColor),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  children: [
                    CameraWidget(),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            ImageAssets.pCornersPic,
                            width: 280 * autoScale,
                            height: 280 * autoScale,
                          ),
                          Obx(() {
                            return ReusableText(
                              text: controller.recognitionLabel.value.isNotEmpty
                                  ? controller.recognitionLabel.value
                                  : "Scan the equipment",
                              size: 16 * autoScale,
                              fontWeight: FontWeight.w500,
                              color: AppColors.pWhiteColor,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 180 * autoScale, // Adjusted height for a responsive navigation bar
        color: AppColors.pBGGreyColor,
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double buttonSize = constraints.maxHeight * 0.45; // Make button 60% of the navbar height

              return Material(
                shape: CircleBorder(),
                elevation: 10.0,
                shadowColor: Colors.black26,
                child: Container(
                  height: buttonSize, // Responsive height for the button
                  width: buttonSize,  // Responsive width for the button
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.pWhiteColor,
                  ),
                  child: IconButton(
                    icon: Image.asset(
                      IconAssets.pCamIconSelected,
                      height: buttonSize * 0.55, // Icon size relative to button size
                    ),
                    onPressed: () {
                      // Implement scan action here
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
