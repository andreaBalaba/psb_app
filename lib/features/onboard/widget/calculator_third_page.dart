import 'package:flutter/material.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class ThirdOnboardPage extends StatelessWidget {
  final double autoScale;

  const ThirdOnboardPage({super.key, required this.autoScale});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pPurpleColor,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              ImageAssets.pCalculatorOBTwo,
              height: 450 * autoScale,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * autoScale),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  ImageAssets.pCalculatorLogo,
                  width: 150 * autoScale,
                  height: 150 * autoScale,
                ),
                SizedBox(height: 30 * autoScale),
                Stack(
                  children: [
                    ReusableText(
                      text: 'Know your\n body!',
                      size: 32 * autoScale,
                      align: TextAlign.center,
                      letterSpacing: 3,
                      color: AppColors.pWhiteColor,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4 * autoScale
                        ..color = AppColors.pPurpleColor,
                    ),
                    // Fill Text
                    ReusableText(
                      text: 'Know your\n body!',
                      size: 32 * autoScale,
                      align: TextAlign.center,
                      letterSpacing: 3,
                      color: AppColors.pWhiteColor,
                    ),
                  ],
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
