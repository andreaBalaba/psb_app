//temporary model

// Updated WorkoutPlan Model
class WorkoutPlan {
  final String imagePath;
  final String title;
  final String subtitle;
  final String duration;
  final String calories;
  bool isTapped;

  WorkoutPlan({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.calories,
    this.isTapped = false,
  });
}

// Updated DailyTask Model
class DailyTask {
  final String imagePath;
  final String title;
  final String duration;
  final String calories;
  bool isTapped;
  bool isCompleted;

  DailyTask({
    required this.imagePath,
    required this.title,
    required this.duration,
    required this.calories,
    this.isTapped = false,
    this.isCompleted = false, // Default to false
  });
}

// Updated Equipment Model
class Equipment {
  final String name;
  final String imagePath;
  final String category;
  final String description;
  final String experienceLevel;
  final String duration; // Duration for using the equipment
  final String calories; // Calories burned using the equipment
  bool isTapped;

  Equipment({
    required this.name,
    required this.imagePath,
    required this.category,
    required this.description,
    required this.experienceLevel,
    this.duration = "N/A", // Optional duration
    this.calories = "N/A", // Optional calories
    this.isTapped = false,
  });
}
