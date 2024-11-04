import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/scanner/controller/scanner_controller.dart';
import 'package:psb_app/utils/global_variables.dart';

class CameraWidget extends StatelessWidget {
  final ScannerController controller = Get.put(ScannerController());

  CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!controller.isCameraInitialized.value) {
      return Center(child: CircularProgressIndicator(color: AppColors.pWhiteColor));
    }

    return Center(
      child: AspectRatio(
        aspectRatio: 3 / 4, // Set to 3:4 to keep portrait proportions
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.cameraController!.value.previewSize!.height,
            height: controller.cameraController!.value.previewSize!.width,
            child: CameraPreview(controller.cameraController!),
          ),
        ),
      ),
    );
  }
}
