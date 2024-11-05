import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/api/dummy_data.dart';
import 'package:psb_app/model/exercise_model.dart';


class MealController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var searchQuery = ''.obs;

  var mealHistoryList = <MealHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMealHistory();
  }

  void loadMealHistory() {
    mealHistoryList.value = MealData().mealHistoryList;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  void addMeal(MealHistory meal) {

    meal.isAdded = true; // Mark the meal as added
    mealHistoryList.refresh(); // Refresh the list to update UI
  }
}
