import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/global_variables.dart';

class EquipmentPage extends StatefulWidget {
  String data;
  bool? isName;

  EquipmentPage({super.key, required this.data, this.isName = false});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  dynamic equipmentData;

  bool hasLoaded = false;
  bool hasStarted = false;
  getData() async {
    String jsonString =
        await rootBundle.loadString('assets/images/Gym-equipments-Datas.json');

    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    List equipments = jsonData['equipment'];

    setState(() {
      equipmentData = equipments.where(
        (element) {
          return element['name'] == widget.data;
        },
      ).first;

      hasLoaded = true;
    });
  }

  String selectedItem = 'Beginner'; // Holds the selected item
  FlutterTts flutterTts = FlutterTts();

  final List<String> items = ['Beginner', 'Intermediate', 'Advanced'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.volume_up,
          size: 20,
          color: AppColors.pBlackColor,
        ),
        onPressed: () async {
          int i = selectedItem == 'Beginner'
              ? 0
              : selectedItem == 'Intermediate'
                  ? 1
                  : 2;
          await flutterTts.setVolume(1.0);

          await flutterTts.speak(
              'Step by step instruction for ${equipmentData['levels'][i]['level']} Level, ${equipmentData['levels'][i]['step_by_step_instructions']}');
        },
      ),
      body: hasLoaded
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReusableText(
                        text: widget.data,
                        fontWeight: FontWeight.w600,
                        size: 18,
                        color: AppColors.pBlack87Color,
                        decoration: null,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Center(
                        child: DropdownButton<String>(
                          value: selectedItem, // The currently selected item
                          hint: const Text('Select Level'), // Placeholder text
                          icon: const Icon(
                              Icons.arrow_drop_down), // Dropdown icon
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            // Update the selected item
                            setState(() {
                              selectedItem = value!;
                            });
                          },
                        ),
                      ),

                      // Indexed Stack
                      Builder(builder: (context) {
                        int i = selectedItem == 'Beginner'
                            ? 0
                            : selectedItem == 'Intermediate'
                                ? 1
                                : 2;
                        return SizedBox(
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 350.0,
                                height: 250.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(equipmentData['levels']
                                            [i]['workouts']
                                        .first['img']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ReusableText(
                                text: equipmentData['levels'][i]['level'],
                                fontWeight: FontWeight.w600,
                                size: 18,
                                color: AppColors.pBlack87Color,
                                decoration: null,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        children: [
                                          ReusableText(
                                            text:
                                                'Set 1 of ${equipmentData['levels'][i]['workouts'].first['sets']}             ${equipmentData['levels'][i]['workouts'].first['reps']} reps/set',
                                            fontWeight: FontWeight.w200,
                                            size: 12,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.timer_outlined,
                                                color: Colors.green,
                                                size: 40,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ReusableText(
                                                text:
                                                    '${equipmentData['levels'][i]['workouts'].first['minutes']}:00',
                                                fontWeight: FontWeight.w600,
                                                size: 24,
                                                color: AppColors.pGreenColor,
                                                decoration: null,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        children: [
                                          const ReusableText(
                                            text: 'Overview',
                                            fontWeight: FontWeight.w600,
                                            size: 18,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          ReusableText(
                                            text: equipmentData['levels'][i]
                                                ['overview'],
                                            fontWeight: FontWeight.w200,
                                            size: 12,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        children: [
                                          const ReusableText(
                                            text: 'Basic Alternatives',
                                            fontWeight: FontWeight.w600,
                                            size: 18,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          ReusableText(
                                            text: equipmentData['levels'][i]
                                                    ['basics_and_alternatives']
                                                ['alternative'],
                                            fontWeight: FontWeight.w200,
                                            size: 12,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const ReusableText(
                                            text: 'Correct Execution',
                                            fontWeight: FontWeight.w600,
                                            size: 18,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            children: [
                                              for (int j = 0;
                                                  j <
                                                      equipmentData['levels'][i]
                                                              [
                                                              'correct_execution']
                                                          .length;
                                                  j++)
                                                ReusableText(
                                                  text: equipmentData['levels']
                                                          [i]
                                                      ['correct_execution'][j],
                                                  fontWeight: FontWeight.w200,
                                                  size: 12,
                                                  color:
                                                      AppColors.pBlack87Color,
                                                  decoration: null,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 20,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        children: [
                                          const ReusableText(
                                            text: 'Step by Step Instructions',
                                            fontWeight: FontWeight.w600,
                                            size: 18,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (int j = 0;
                                                  j <
                                                      equipmentData['levels'][i]
                                                              [
                                                              'step_by_step_instructions']
                                                          .length;
                                                  j++)
                                                ReusableText(
                                                  text: equipmentData['levels']
                                                          [i][
                                                      'step_by_step_instructions'][j],
                                                  fontWeight: FontWeight.w200,
                                                  size: 12,
                                                  color:
                                                      AppColors.pBlack87Color,
                                                  decoration: null,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 20,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        children: [
                                          const ReusableText(
                                            text: 'Common Mistakes',
                                            fontWeight: FontWeight.w600,
                                            size: 18,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (int j = 0;
                                                  j <
                                                      equipmentData['levels'][i]
                                                              [
                                                              'common_mistakes']
                                                          .length;
                                                  j++)
                                                ReusableText(
                                                  text: equipmentData['levels']
                                                      [i]['common_mistakes'][j],
                                                  fontWeight: FontWeight.w200,
                                                  size: 12,
                                                  color:
                                                      AppColors.pBlack87Color,
                                                  decoration: null,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 20,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        children: [
                                          const ReusableText(
                                            text: 'Video Tutorial',
                                            fontWeight: FontWeight.w600,
                                            size: 18,
                                            color: AppColors.pBlack87Color,
                                            decoration: null,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await launchUrlString(
                                                  equipmentData['levels'][i]
                                                      ['video_tutorial']);
                                            },
                                            child: ReusableText(
                                              text: equipmentData['levels'][i]
                                                  ['video_tutorial'],
                                              fontWeight: FontWeight.w800,
                                              size: 18,
                                              color: AppColors.pGreenColor,
                                              decoration: null,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: hasStarted,
                        child: const ReusableText(
                          text: 'Great, you can proceed now !',
                          fontWeight: FontWeight.w600,
                          size: 18,
                          color: AppColors.pBlack87Color,
                          decoration: null,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ReusableButton(
                        text: hasStarted ? 'Finish' : "Start",
                        onPressed: () {
                          if (!hasStarted) {
                            setState(() {
                              hasStarted = true;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        color: AppColors.pGreenColor,
                        fontColor: AppColors.pWhiteColor,
                        borderRadius: 100,
                        size: 22,
                        weight: FontWeight.w600,
                        removePadding: true,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
