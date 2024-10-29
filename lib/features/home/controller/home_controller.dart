import 'package:get/get.dart';
import 'package:psb_app/api/dummy_data.dart';
import 'package:psb_app/features/calculator/screen/side_calculator_page.dart';
import 'package:psb_app/features/onboard/calculator_onboard_page.dart';
import 'package:psb_app/model/exercise_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  var dailyTasks = <DailyTask>[].obs;
  var workoutPlans = <WorkoutPlan>[].obs;
  var showShadow = false.obs;

  @override
  void onInit() {
    super.onInit();
    dailyTasks.value = DailyTasksData.getDailyTasks();
    workoutPlans.value = WorkoutPlanData.getWorkoutPlans();
  }

  int get completedTasksCount => dailyTasks.where((task) => task.isCompleted).length;
  int get totalTasksCount => dailyTasks.length;


  Future<bool> checkOnboardingCompletion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingCompleted') ?? false;
  }

  // Method to set onboarding as completed
  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
  }

  Future<void> navigateToCalculator() async {
    bool isOnboardingCompleted = await checkOnboardingCompletion();
    if (isOnboardingCompleted) {
      Get.to(() => const MainCalculatorPage(), transition: Transition.leftToRight);
    } else {
      // Go to onboarding first if it's not completed
      Get.to(() => OnboardCalculator(
        onComplete: () async {
          await completeOnboarding(); // Mark as complete on skip or get started
          Get.off(() => const MainCalculatorPage(), transition: Transition.leftToRight);
        },
      ), transition: Transition.leftToRight);
    }
  }
}


