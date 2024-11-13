import 'package:psb_app/model/exercise_model.dart';
import 'package:psb_app/utils/global_assets.dart';

class WorkoutPlanData {
  static List<WorkoutPlan> getWorkoutPlans() {
    return [
      WorkoutPlan(
        imagePath: ImageAssets.dummyPicOne,
        title: 'Chest Building',
        subtitle: 'Full chest workouts',
        duration: '30 mins',
        calories: '200 kcal',
      ),
      WorkoutPlan(
        imagePath: ImageAssets.dummyPicOne,
        title: 'Back Strength',
        subtitle: 'Full back workouts',
        duration: '40 mins',
        calories: '250 kcal',
      ),
      WorkoutPlan(
        imagePath: ImageAssets.dummyPicOne,
        title: 'Leg Day',
        subtitle: 'Intense leg workouts',
        duration: '45 mins',
        calories: '300 kcal',
      ),
      WorkoutPlan(
        imagePath: ImageAssets.dummyPicOne,
        title: 'Leg Day',
        subtitle: 'Intense leg workouts',
        duration: '45 mins',
        calories: '300 kcal',
      ),
      // Add more workout plans as needed
    ];
  }
}

class DailyTasksData {
  static List<DailyTask> getDailyTasks() {
    return [
      DailyTask(
        imagePath: ImageAssets.dummyPicTwo,
        title: 'Flat bench press',
        duration: '15 mins',
        calories: '50 kcal',
        //isCompleted: true,
      ),
      DailyTask(
        imagePath: ImageAssets.dummyPicThree,
        title: 'Incline bench press',
        duration: '30 mins',
        calories: '200 kcal',
        //isCompleted: false,
      ),
      DailyTask(
        imagePath: ImageAssets.dummyPicTwo,
        title: 'Evening Run',
        duration: '30 mins',
        calories: '200 kcal',
        //isCompleted: false,
      ),
      DailyTask(
        imagePath: ImageAssets.dummyPicTwo,
        title: 'Evening Run',
        duration: '30 mins',
        calories: '200 kcal',
        //isCompleted: false,
      ),
      DailyTask(
        imagePath: ImageAssets.dummyPicTwo,
        title: 'Evening Run',
        duration: '30 mins',
        calories: '200 kcal',
        //isCompleted: false,
      ),
      DailyTask(
        imagePath: ImageAssets.dummyPicTwo,
        title: 'Evening Run',
        duration: '30 mins',
        calories: '200 kcal',
        //isCompleted: false,
      ),
      DailyTask(
        imagePath: ImageAssets.dummyPicTwo,
        title: 'Evening Run',
        duration: '30 mins',
        calories: '200 kcal',
        //isCompleted: false,
      ),
      DailyTask(
        imagePath: ImageAssets.dummyPicTwo,
        title: 'Evening Run',
        duration: '30 mins',
        calories: '200 kcal',
        //isCompleted: false,
      ),
      // Add more tasks as needed
    ];
  }
}

class EquipmentData {
  static List<Equipment> getEquipmentList() {
    return [
      Equipment(
        name: 'Leg Extension Machine',
        imagePath: ImageAssets.dummyPicThree,
        category: 'Leg Equipment',
        description: 'Strengthen your quadriceps with leg extensions.',
        experienceLevel: 'Beginner', // New experience level
      ),
      Equipment(
        name: 'Leg Press',
        imagePath: ImageAssets.dummyPicThree,
        category: 'Leg Equipment',
        description: 'Build strength in your lower body.',
        experienceLevel: 'Intermediate', // New experience level
      ),
      Equipment(
        name: 'Chest Press Machine',
        imagePath: ImageAssets.dummyPicThree,
        category: 'Chest Equipment',
        description: 'Engage your pectoral muscles effectively.',
        experienceLevel: 'Advance', // New experience level
      ),
      Equipment(
        name: 'Butterfly Machine',
        imagePath: ImageAssets.dummyPicThree,
        category: 'Chest Equipment',
        description: 'Great for isolating your chest muscles.',
        experienceLevel: 'Beginner',
      ),
      Equipment(
        name: 'Lat Pulldown Machine',
        imagePath: ImageAssets.dummyPicThree,
        category: 'Back Equipment',
        description: 'Strengthen your upper back muscles.',
        experienceLevel: 'Intermediate',
      ),
      Equipment(
        name: 'Dumbbells',
        imagePath: ImageAssets.dummyPicThree,
        category: 'Hand Weights',
        description: 'Versatile equipment for various exercises.',
        experienceLevel: 'Advance',
      ),
      // Add more items as needed
    ];
  }
}

class MealData {
  final List<MealHistory> mealHistoryList = [
    MealHistory(
      title: "Ginisang Munggo",
      imagePath: ImageAssets.dummyPicFour,
      calories: "300 kcal",
      weight: "400 grams",
    ),
    MealHistory(
      title: "Ginisang Munggo",
      imagePath: ImageAssets.dummyPicFour,
      calories: "300 kcal",
      weight: "400 grams",
    ),
    MealHistory(
      title: "Ginisang Munggo",
      imagePath: ImageAssets.dummyPicFour,
      calories: "300 kcal",
      weight: "400 grams",
    ),
    MealHistory(
      title: "Ginisang Munggo",
      imagePath: ImageAssets.dummyPicFour,
      calories: "300 kcal",
      weight: "400 grams",
    ),
    MealHistory(
      title: "Ginisang Munggo",
      imagePath: ImageAssets.dummyPicFour,
      calories: "300 kcal",
      weight: "400 grams",
    ),
    MealHistory(
      title: "Ginisang Munggo",
      imagePath: ImageAssets.dummyPicFour,
      calories: "300 kcal",
      weight: "400 grams",
    ),
    MealHistory(
      title: "Ginisang Munggo",
      imagePath: ImageAssets.dummyPicFour,
      calories: "300 kcal",
      weight: "400 grams",
    ),
  ];
}
