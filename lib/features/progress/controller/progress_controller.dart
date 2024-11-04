import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class ProgressController extends GetxController {
  final ScrollController scrollController = ScrollController();

  var stepCount = 0.obs;

  Stream<StepCount>? _stepCountStream;

  @override
  void onInit() {
    super.onInit();
    _initStepCounter();
  }

  void _initStepCounter() {
    try {
      // Listen to the step count stream
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream?.listen(
            (StepCount stepCountData) {
          // Update the step count with the current steps
          stepCount.value = stepCountData.steps;
        },
        onError: (error) {
          print("Step Count Error: $error");
        },
        cancelOnError: true,
      );
    } catch (e) {
      print("Error initializing step counter: $e");
    }
  }

  @override
  void onClose() {
    // Dispose of the stream if necessary
    _stepCountStream = null;
    super.onClose();
  }
}
