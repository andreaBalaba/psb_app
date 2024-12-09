import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';

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
          return widget.isName!
              ? element['name'] == widget.data
              : element['exercise'] == widget.data;
        },
      ).first;

      hasLoaded = true;
    });
  }

  FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.volume_up,
          size: 20,
          color: AppColors.pBlackColor,
        ),
        onPressed: () async {
          await flutterTts.setVolume(1.0);

          for (int i = 0; i < equipmentData['levels'].length; i++) {
            await flutterTts.speak(
                'Step by step instruction for ${equipmentData['levels'][i]['level']} Level, ${equipmentData['levels'][i]['step_by_step_instructions']}');
          }
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
                      Container(
                        width: 350.0,
                        height: 250.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(equipmentData['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Indexed Stack
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0;
                                i < equipmentData['levels'].length;
                                i++)
                              SizedBox(
                                width: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                          ],
                        ),
                      ),
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
