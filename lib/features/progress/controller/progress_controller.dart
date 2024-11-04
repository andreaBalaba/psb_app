import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressController extends GetxController {
  final ScrollController scrollController = ScrollController();

  // Observable variables for step count
  var stepCount = 0.obs;
  var hourlySteps = List<int>.filled(24, 0).obs;
  var todayStepCount = 0.obs;
  var weeklyAverageStepCount = 0.0.obs;
  var monthlyAverageStepCount = 0.0.obs;

  // Historical data lists
  List<int> last7DaysSteps = [];
  List<int> last30DaysSteps = [];

  Stream<StepCount>? _stepCountStream;

  final String _lastSavedStepsKey = 'last_saved_steps';
  final String _lastSavedDateKey = 'last_saved_date';
  final String _dailyStepsHistoryKey = 'daily_steps_history';

  @override
  void onInit() {
    super.onInit();
    _initStepCounter();
  }

  void _initStepCounter() async {
    final prefs = await SharedPreferences.getInstance();
    int lastSavedSteps = prefs.getInt(_lastSavedStepsKey) ?? 0;
    String lastSavedDate = prefs.getString(_lastSavedDateKey) ?? '';
    _loadHistoricalData();

    if (!_isSameDay(DateTime.now(), DateTime.tryParse(lastSavedDate))) {
      _saveDailyStepCount(todayStepCount.value);
      lastSavedSteps = 0;
      _resetDailyData();
    }
    stepCount.value = lastSavedSteps;

    try {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream?.listen(
            (StepCount stepCountData) {
          int currentSteps = stepCountData.steps - lastSavedSteps;
          if (currentSteps < 0) currentSteps = 0;

          stepCount.value = currentSteps;
          todayStepCount.value = currentSteps;

          int currentHour = DateTime.now().hour;
          hourlySteps[currentHour] = currentSteps;

          _saveStepData(stepCountData.steps);
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

  Future<void> _saveStepData(int totalSteps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSavedStepsKey, totalSteps);
    await prefs.setString(_lastSavedDateKey, DateTime.now().toIso8601String());
  }

  Future<void> _saveDailyStepCount(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_dailyStepsHistoryKey) ?? [];
    if (history.length >= 30) history.removeAt(0);
    history.add(steps.toString());
    await prefs.setStringList(_dailyStepsHistoryKey, history);
    _loadHistoricalData();
  }

  void _loadHistoricalData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_dailyStepsHistoryKey) ?? [];
    List<int> stepsList = history.map((e) => int.tryParse(e) ?? 0).toList();

    last7DaysSteps = stepsList.takeLast(7).toList();
    last30DaysSteps = stepsList.takeLast(30).toList();

    weeklyAverageStepCount.value = last7DaysSteps.isNotEmpty
        ? last7DaysSteps.reduce((a, b) => a + b) / last7DaysSteps.length
        : 0.0;
    monthlyAverageStepCount.value = last30DaysSteps.isNotEmpty
        ? last30DaysSteps.reduce((a, b) => a + b) / last30DaysSteps.length
        : 0.0;
  }

  void _resetDailyData() {
    hourlySteps.value = List<int>.filled(24, 0);
    todayStepCount.value = 0;
  }

  bool _isSameDay(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Computed property for daily average
  double get dailyAverageStepCount {
    if (last7DaysSteps.isNotEmpty) {
      return last7DaysSteps.reduce((a, b) => a + b) / last7DaysSteps.length;
    }
    return 0.0;
  }
}

extension TakeLastExtension<T> on List<T> {
  List<T> takeLast(int n) => length >= n ? sublist(length - n) : this;
}
