import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReusableText(
              text: "Intermediate",
              size: 18 * autoScale,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            SizedBox(width: 4 * autoScale),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 24 * autoScale,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scanner frame
            Container(
              width: 200 * autoScale,
              height: 200 * autoScale,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 4 * autoScale,
                ),
                borderRadius: BorderRadius.circular(8 * autoScale),
              ),
              child: Center(
                child: ReusableText(
                  text: "Scan the equipment",
                  size: 16 * autoScale,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20 * autoScale),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // Implement scan action here
        },
        child: Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 30 * autoScale,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
