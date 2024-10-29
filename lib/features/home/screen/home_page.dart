import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/controller/home_controller.dart';
import 'package:psb_app/features/home/screen/widget/daily_task_widget.dart';
import 'package:psb_app/features/home/screen/widget/today_plan_card_widget.dart';
import 'package:psb_app/features/home/screen/widget/workout_plan_widget.dart';
import 'package:psb_app/features/library/screen/library_page.dart';
import 'package:psb_app/features/scanner/screen/scanner_page.dart';
import 'package:psb_app/features/settings/screen/setting_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.put(HomeController());
  int _currentIndex = 0;
  final String userName = "Andeng Balaba";
  bool _isButtonDragged = false;
  double _buttonVerticalPosition = 0;
  bool _showShadow = false;
  double autoScale = Get.width / 400;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _dailyTaskKey = GlobalKey(); // GlobalKey for Daily Task Section

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_currentIndex == 0) {
      if (_scrollController.position.pixels > 0 && !_showShadow) {
        setState(() {
          _showShadow = true;
        });
      } else if (_scrollController.position.pixels <= 0 && _showShadow) {
        setState(() {
          _showShadow = false;
        });
      }
    }
  }

  // Method to scroll to the Daily Task section
  void _scrollToDailyTask() {
    final RenderBox? renderBox = _dailyTaskKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero).dy;
      _scrollController.animateTo(
        _scrollController.offset + position - 100, // Adjust this offset as needed
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        elevation: _showShadow ? 4.0 : 0.0,
        surfaceTintColor: AppColors.pNoColor,
        shadowColor: _showShadow ? Colors.black26 : Colors.transparent,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Image.asset(
                  IconAssets.pChatBotIcon,
                  height: 30 * autoScale,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  IconAssets.pSettingIcon,
                  height: 30 * autoScale,
                ),
                onPressed: () {
                  Get.to(() => SettingsPage(), transition: Transition.rightToLeft);
                },
              ),
              const SizedBox(width: 2.0),
            ],
          ),
        ],
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: const AssetImage(IconAssets.pUserIcon),
                radius: 20 * autoScale,
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: ReusableText(
                  text: userName,
                  size: 20 * autoScale,
                  fontWeight: FontWeight.w500,
                  color: AppColors.pBlackColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildPageContent(),

          Positioned(
            top: _isButtonDragged ? _buttonVerticalPosition : 0,
            left: 0, // Flush against the left edge
            child: GestureDetector(
              onTap: () {
                homeController.navigateToCalculator();
              },
              child: Image.asset(
                IconAssets.pSideIcon,
                width: 30.0,
                height: 30.0,
                fit: BoxFit.contain,
              ),
              onPanUpdate: (details) {
                setState(() {
                  _isButtonDragged = true;
                  _buttonVerticalPosition =
                      (details.globalPosition.dy - 40).clamp(
                        0,
                        screenHeight - 250,
                      );
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(autoScale),
    );
  }

  // Define the content methods for each page
  Widget _buildPageContent() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildLibraryContent();
      case 2:
        return _buildScannerContent();
      case 3:
        return _buildProgressContent();
      case 4:
        return _buildMealContent();
      default:
        return _buildHomeContent();
    }
  }

  // Home Page Content
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0 * autoScale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15 * autoScale), // Space between header and PlanCard
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0 * autoScale),
              child: GestureDetector(
                onTap: _scrollToDailyTask, // Scroll to Daily Task
                child: PlanCardWidget(),
              ),
            ),
            SizedBox(height: 20 * autoScale),
            WorkoutPlanList(),
            SizedBox(height: 15 * autoScale),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0 * autoScale),
              child: DailyTaskList(key: _dailyTaskKey), // Assign the GlobalKey here
            ),
          ],
        ),
      ),
    );
  }

  // Library Page Content
  Widget _buildLibraryContent() {
    return Center(
      child: LibraryPage(),
    );
  }

  // Scanner Page Content
  Widget _buildScannerContent() {
    return Center(
      child: ScannerPage(),
    );
  }

  // Progress Page Content
  Widget _buildProgressContent() {
    return Center(
      child: ReusableText(
        text: "Track Your Progress Here",
        fontWeight: FontWeight.w600,
        size: 20 * (Get.width / 400),
        color: AppColors.pBlackColor,
      ),
    );
  }

  // Meal Page Content
  Widget _buildMealContent() {
    return Center(
      child: ReusableText(
        text: "Meal Plans and Nutrition",
        fontWeight: FontWeight.w600,
        size: 20 * (Get.width / 400),
        color: AppColors.pBlackColor,
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavigationBar(double autoScale) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.pBGWhiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.pBlack12Color,
            offset: Offset(0, -2),
            blurRadius: 15.0,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          BottomNavigationBar(
            backgroundColor: AppColors.pBGWhiteColor,
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == 2) {
                // Directly navigate to ScannerPage if camera icon is selected
                Get.to(() => ScannerPage());
              } else {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(
                icon: IconAssets.pHomeIcon,
                selectedIcon: IconAssets.pHomeIconSelected,
                label: 'Home',
                isSelected: _currentIndex == 0,
              ),
              _buildNavItem(
                icon: IconAssets.pLibIcon,
                selectedIcon: IconAssets.pLibIconSelected,
                label: 'Library',
                isSelected: _currentIndex == 1,
              ),
              _buildNavItem(
                icon: IconAssets.pCamIcon,
                selectedIcon: IconAssets.pCamIconSelected,
                label: 'Scanner',
                isSelected: _currentIndex == 2,
              ),
              _buildNavItem(
                icon: IconAssets.pProgressIcon,
                selectedIcon: IconAssets.pProgressIconSelected,
                label: 'Progress',
                isSelected: _currentIndex == 3,
              ),
              _buildNavItem(
                icon: IconAssets.pMealIcon,
                selectedIcon: IconAssets.pMealIconSelected,
                label: 'Meal',
                isSelected: _currentIndex == 4,
              ),
            ],
            selectedItemColor: AppColors.pGreenColor,
            unselectedItemColor: AppColors.pBlackColor,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12 * autoScale,
              fontFamily: 'Poppins'
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12 * autoScale, fontFamily: 'Poppins'
            ),
          ),
          Positioned(
            top: -4,
            left: _currentIndex * (Get.width / 5) + (Get.width / 10) - 25,
            child: Image.asset(
              IconAssets.pLine,
              width: 50,
              height: 10,
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String icon,
    required String selectedIcon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        isSelected ? selectedIcon : icon,
        height: 30 * autoScale,
      ),
      label: label,
    );
  }
}
