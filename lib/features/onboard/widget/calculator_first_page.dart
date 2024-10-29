import 'package:flutter/material.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class FirstOnboardPage extends StatelessWidget {
  final double autoScale;

  const FirstOnboardPage({super.key, required this.autoScale});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pPurpleColor, // Use your main purple color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Spacer(flex: 1),
          Image.asset(
            ImageAssets.pCalculatorLogo,
            width: 200 * autoScale, // Use autoScale for responsive width
            height: 200 * autoScale, // Use autoScale for responsive height
          ),
          SizedBox(height: 40 * autoScale), // Use autoScale for spacing
          ReusableText(
            text: 'Calculate\nit right!',
            size: 32 * autoScale, // Responsive font size
            color: AppColors.pWhiteColor, // Change to your desired color
            align: TextAlign.center,
            letterSpacing: 3,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
