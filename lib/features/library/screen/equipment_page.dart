import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class EquipmentDetailsPage extends StatefulWidget {
  final String imagePath;
  final String name;
  final String level;
  final String duration;
  final String calories;
  final String description;

  const EquipmentDetailsPage({
    super.key,
    required this.imagePath,
    required this.name,
    required this.level,
    required this.duration,
    required this.calories,
    required this.description,
  });

  @override
  State<EquipmentDetailsPage> createState() => _EquipmentDetailsPageState();
}

class _EquipmentDetailsPageState extends State<EquipmentDetailsPage> {
  double autoScale = Get.width / 360;
  late String selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.level; // Set initial level from the passed value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        surfaceTintColor: AppColors.pNoColor,
        elevation: 0.5,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0 * autoScale,
          left: 16.0 * autoScale,
          right: 16.0 * autoScale,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ReusableText(
                    text: widget.name,
                    fontWeight: FontWeight.bold,
                    size: 22 * autoScale,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0 * autoScale),
                    decoration: BoxDecoration(
                      color: AppColors.pBGWhiteColor,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLevel,
                        icon: Icon(Icons.arrow_drop_down, color: AppColors.pGreyColor),
                        alignment: Alignment.center,
                        items: ["Beginner", "Intermediate", "Advance"]
                            .map((level) => DropdownMenuItem<String>(
                          value: level,
                          child: Center(
                            child: ReusableText(
                              text: level,
                              fontWeight: FontWeight.w500,
                              size: 14 * autoScale,
                              color: AppColors.pGreyColor,
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedLevel = newValue!;
                          });
                        },
                        style: TextStyle(
                          color: AppColors.pBlackColor,
                          fontFamily: 'Poppins',
                          fontSize: 14 * autoScale,
                        ),
                        dropdownColor: AppColors.pBGWhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20 * autoScale),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0 * autoScale),
                  color: AppColors.pBlack87Color,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0 * autoScale),
                  child: Image.asset(
                    widget.imagePath,
                    width: double.infinity,
                    height: 200 * autoScale,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16 * autoScale),

            Center(
              child: Container(
                padding: EdgeInsets.all(12.0 * autoScale),
                decoration: BoxDecoration(
                  color: AppColors.pBlack12Color,
                  borderRadius: BorderRadius.circular(12.0 * autoScale),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          IconAssets.pClockIcon,
                          color: AppColors.pDarkGreenColor,
                          height: 18 * autoScale,
                          width: 18 * autoScale,
                        ),
                        SizedBox(width: 4.0 * autoScale),
                        ReusableText(
                          text: widget.duration,
                          size: 14.0 * autoScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pDarkGreenColor,
                        ),
                      ],
                    ),
                    SizedBox(width: 12 * autoScale),
                    Container(
                      height: 20 * autoScale,
                      width: 1.0,
                      color: AppColors.pBlackColor,
                    ),
                    SizedBox(width: 12 * autoScale),

                    Row(
                      children: [
                        Image.asset(
                          IconAssets.pFireIcon,
                          color: AppColors.pDarkOrangeColor,
                          height: 18 * autoScale,
                          width: 18 * autoScale,
                        ),
                        SizedBox(width: 4.0 * autoScale),
                        ReusableText(
                          text: "${widget.calories} kcal",
                          size: 14.0 * autoScale,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pDarkOrangeColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20 * autoScale),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ReusableText(
                  text: "Proper usage",
                  fontWeight: FontWeight.bold,
                  size: 20 * autoScale,
                ),
                SizedBox(width: 8 * autoScale),
                Icon(
                  Icons.volume_up,
                  size: 20 * autoScale,
                  color: AppColors.pBlackColor,
                ),
              ],
            ),
            SizedBox(height: 10 * autoScale),

            Expanded(
              child: SingleChildScrollView(
                child: ReusableText(
                  text: widget.description,
                  size: 14 * autoScale,
                  align: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
