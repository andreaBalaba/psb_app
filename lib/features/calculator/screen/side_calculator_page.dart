import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/calculator/screen/widget/bmi_widget.dart';
import 'package:psb_app/features/calculator/screen/widget/calories_widget.dart';
import 'package:psb_app/features/calculator/screen/widget/protein_widget.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';


class MainCalculatorPage extends StatefulWidget {
  const MainCalculatorPage({super.key});

  @override
  State<MainCalculatorPage> createState() => _MainCalculatorPageState();
}

class _MainCalculatorPageState extends State<MainCalculatorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
      }
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 400;

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pPurpleColor,
        surfaceTintColor: AppColors.pNoColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white54,
        ),
        title: ReusableText(
          text: "",
          size: 20 * autoScale,
          fontWeight: FontWeight.w500,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              indicatorColor: AppColors.pNoColor,
              labelPadding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              tabs: [
                _buildCustomTab('Protein', 0, autoScale),
                _buildCustomTab('BMI', 1, autoScale),
                _buildCustomTab('Calories', 2, autoScale),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
        children: const [
          ProteinWidget(),
          BmiWidget(),
          CaloriesWidget(),
        ],
      ),
    );
  }

  Widget _buildCustomTab(String text, int index, double autoScale) {
    bool isSelected = _tabController.index == index;

    return AnimatedBuilder(
      animation: _tabController.animation!,
      builder: (context, child) {
        isSelected = _tabController.index == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _tabController.animateTo(index);
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            width: Get.width / 3,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.pWhiteColor : AppColors.pPurpleColor,
              borderRadius: isSelected
                  ? const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              )
                  : BorderRadius.zero,
            ),
            child: ReusableText(
              text: text,
              size: 16 * autoScale,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.pBlackColor : AppColors.pWhiteColor,
            ),
          ),
        );
      },
    );
  }
}
