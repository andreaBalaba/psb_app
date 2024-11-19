import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/meal/controller/meal_controller.dart';
import 'package:psb_app/features/meal/screen/add_meal_page.dart';
import 'package:psb_app/features/meal/screen/widget/meal_card_widget.dart';
import 'package:psb_app/features/meal/screen/widget/meal_history_widget.dart';
import 'package:psb_app/features/meal/screen/widget/search_bar_widget.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage>
    with AutomaticKeepAliveClientMixin {
  final MealController controller = Get.put(MealController());
  double autoScale = Get.width / 360;
  bool _showShadow = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.scrollController.hasClients &&
          controller.scrollController.offset > 0) {
        setState(() {
          _showShadow = true;
        });
      }
    });

    controller.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.scrollController.offset > 0 && !_showShadow) {
      setState(() {
        _showShadow = true;
      });
    } else if (controller.scrollController.offset <= 0 && _showShadow) {
      setState(() {
        _showShadow = false;
      });
    }
  }

  @override
  void dispose() {
    controller.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        elevation: _showShadow ? 6.0 : 0.0,
        shadowColor: Colors.black26,
        surfaceTintColor: AppColors.pNoColor,
        title: SearchBarWidget(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MealCardWidget(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(
                  text: "Create meal",
                  onPressed: () {
                    // Action for Create meal
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddMealPage()));
                  },
                ),
                const SizedBox(width: 15),
                _buildButton(
                  text: "Quick add",
                  onPressed: () {
                    // Action for Quick add
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const MealHistoryList()
          ],
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0 * autoScale),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.pOrangeColor,
            padding: EdgeInsets.symmetric(vertical: 12.0 * autoScale),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0 * autoScale),
            ),
            elevation: 3,
          ),
          child: ReusableText(
            text: text,
            fontWeight: FontWeight.bold,
            size: 18.0 * autoScale,
          ),
        ),
      ),
    );
  }
}
