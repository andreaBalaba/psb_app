import 'package:flutter/material.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class FourthOnboardPage extends StatelessWidget {
  final double autoScale;
  final VoidCallback onComplete; // Add a callback for navigation

  const FourthOnboardPage({super.key, required this.autoScale, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pPurpleColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              ImageAssets.pCalculatorOBThree, // Update with the correct asset path
              width: 250 * autoScale, // Adjust width as needed
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center, // Align children to the center
              children: [
                Image.asset(
                  ImageAssets.pCalculatorLogo,
                  width: 150 * autoScale, // Responsive size
                  height: 150 * autoScale, // Responsive size
                ),
                SizedBox(height: 40 * autoScale), // Responsive padding
                ReusableText(
                  text: 'Know How Many\n Calories You\n Burn Every Day',
                  size: 32 * autoScale, // Responsive font size
                  color: AppColors.pWhiteColor, // Desired color
                  align: TextAlign.center,
                  letterSpacing: 3,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.pPurpleColor,
                      backgroundColor: Colors.white, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    ),
                    child: const ReusableText(
                      text: 'Get Started',
                      size: 18, // Adjust font size if needed
                      fontWeight: FontWeight.bold,
                      color: AppColors.pPurpleColor, // Button text color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
