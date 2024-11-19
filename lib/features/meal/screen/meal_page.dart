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
                    quickMealDialog();
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

  quickMealDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Quick add',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const _InputRow(label: 'Fat'),
                const SizedBox(height: 12),
                const _InputRow(label: 'Protein'),
                const SizedBox(height: 12),
                const _InputRow(label: 'Calories'),
                const SizedBox(height: 12),
                const _InputRow(label: 'Carbohydrates'),
                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      thickness: 1,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InputRow extends StatelessWidget {
  final String label;

  const _InputRow({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Container(
          width: 100,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
