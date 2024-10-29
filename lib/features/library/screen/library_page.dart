import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/library/controller/library_controller.dart';
import 'package:psb_app/features/library/screen/equipment_page.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class LibraryPage extends StatelessWidget {
  final LibraryController controller = Get.put(LibraryController());
  final ScrollController scrollController = ScrollController();

  LibraryPage({super.key}) {
    scrollController.addListener(() {
      controller.updateShadow(scrollController.position.pixels);
    });
  }

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360; // Define autoScale once here

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        title: ReusableText(
          text: 'Equipment Library',
          fontWeight: FontWeight.bold,
          size: 20 * autoScale, // Use autoScale for responsive sizing
        ),
        backgroundColor: AppColors.pBGWhiteColor,
        surfaceTintColor: Colors.transparent,
        elevation: controller.showShadow.value ? 6.0 : 0.0,
        shadowColor: Colors.black26,
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: 16.0 * autoScale,
          vertical: 8.0 * autoScale,
        ),
        itemCount: controller.equipmentList.length,
        itemBuilder: (context, index) {
          final equipment = controller.equipmentList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0 * autoScale), // Increased spacing
            child: GestureDetector(
              onTap: () {
                Get.to(() => EquipmentDetailsPage(
                  imagePath: equipment.imagePath,
                  name: equipment.name,
                  level: equipment.experienceLevel,
                  duration: equipment.duration,
                  calories: equipment.calories,
                  description: equipment.description,
                ));              },
              child: Container(
                height: 120 * autoScale,
                decoration: BoxDecoration(
                  color: controller.getCategoryColor(equipment.category),
                  borderRadius: BorderRadius.circular(12.0 * autoScale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3 * autoScale,
                      offset: Offset(0, 3 * autoScale),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 5 * autoScale),
                    Padding(
                      padding: EdgeInsets.all(8.0 * autoScale),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0 * autoScale),
                        child: Image.asset(
                          equipment.imagePath,
                          width: 80 * autoScale,
                          height: 80 * autoScale,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 5 * autoScale),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.0 * autoScale),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReusableText(
                              text: equipment.name,
                              fontWeight: FontWeight.bold,
                              size: 18.0 * autoScale,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4 * autoScale),
                            ReusableText(
                              text: 'Level: ${equipment.experienceLevel}',
                              fontWeight: FontWeight.w500,
                              size: 14.0 * autoScale,
                            ),
                            SizedBox(height: 4 * autoScale),
                            ReusableText(
                              text: 'See details',
                              color: AppColors.pBlack87Color,
                              size: 12.0 * autoScale,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}
