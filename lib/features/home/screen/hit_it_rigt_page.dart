import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/screen/daily_task_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class HitItRigtPage extends StatefulWidget {
  dynamic data;

  HitItRigtPage({super.key, required this.data});

  @override
  State<HitItRigtPage> createState() => _HitItRigtPageState();
}

class _HitItRigtPageState extends State<HitItRigtPage> {
  int totalItems = 0;
  late List<bool> isChecked; // List to track checkbox states
  int completedCount = 0; // Track the number of completed items

  @override
  void initState() {
    super.initState();
    totalItems = widget.data['plan_info'].first['plan_workouts'].length;
    isChecked =
        List.generate(totalItems, (index) => false); // Initially all unchecked
  }

  void toggleCheckbox(int index, bool? value) {
    setState(() {
      isChecked[index] = value ?? false; // Update the checkbox state
      completedCount = isChecked
          .where((checked) => checked)
          .length; // Recalculate completed count
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  ReusableText(
                    text: widget.data['name'],
                    fontWeight: FontWeight.bold,
                    size: 28,
                    color: AppColors.pBlackColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 10),
                  _buildInfoChip(
                    context,
                    iconPath: IconAssets.pFireIcon,
                    label: widget.data['plan_calories_burned'].toString(),
                    color: AppColors.pDarkOrangeColor,
                    backgroundColor: AppColors.pLightOrangeColor,
                    borderColor: AppColors.pDarkOrangeColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ReusableText(
                text: widget.data['short_description'],
                fontWeight: FontWeight.normal,
                size: 12,
                color: AppColors.pGreyColor,
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const ReusableText(
                text: 'Exercise',
                fontWeight: FontWeight.bold,
                size: 24,
                color: AppColors.pBlackColor,
                overflow: TextOverflow.ellipsis,
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '$completedCount/$totalItems Complete',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      widget.data['plan_info'].first['plan_workouts'].length,
                  itemBuilder: (context, index) {
                    final workout =
                        widget.data['plan_info'].first['plan_workouts'][index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DailyTaskPage(
                                    calories:
                                        widget.data['plan_calories_burned'],
                                    data: workout,
                                  )));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                            color: isChecked[index]
                                ? AppColors.pGreenColor
                                : AppColors.pGrey400Color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                checkColor: Colors.black,
                                activeColor: Colors.white,
                                hoverColor: Colors.white,
                                value: isChecked[index],
                                onChanged: (value) =>
                                    toggleCheckbox(index, value),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        workout['image'],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      workout['exercise'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Set  ${workout['sets']} ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13,
                                            color: Colors.orange,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Text(
                                          ' - ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            color: Colors.orange,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '${workout['reps']} Reps ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13,
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(
                                  width: 25,
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required String iconPath,
    required String label,
    required Color color,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    double autoScale = Get.width / 360;

    return Container(
      padding:
          EdgeInsets.all(3.0 * autoScale), // Reduced padding for smaller chip
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0 * autoScale), // Smaller radius
        border: Border.all(color: borderColor, width: 1.0 * autoScale),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            height: 12.0 * autoScale, // Reduced icon size
            width: 12.0 * autoScale,
            color: color,
          ),
          SizedBox(width: 4.0 * autoScale),
          ReusableText(
            text: label,
            size: 11.0 * autoScale, // Increased text size
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ],
      ),
    );
  }
}
