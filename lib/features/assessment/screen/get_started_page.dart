import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/assessment/screen/start_assessment_page.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_button.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:video_player/video_player.dart';


class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  late VideoPlayerController _controller;
  double autoScale = Get.width / 400;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/vid_bg.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0.0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Video Background
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
                : Container(),
          ),

          Container(
            color: AppColors.pWhite70Color,
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0 * autoScale),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    ReusableText(
                      text: 'Be the best\nversion of\nyourself\nnow!',
                      size: 45 * autoScale,
                      align: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 5,
                    ),
                    SizedBox(height: 60.0 * autoScale),
                  ],
                ),
              ),
            ),
          ),

          // Transparent Bottom Navigation Button
          Positioned(
            bottom: 40.0 * autoScale,
            left: 20.0 * autoScale,
            right: 20.0 * autoScale,
            child: SizedBox(
              height: screenHeight * 0.065,
              width: double.infinity,
              child: ReusableButton(
                text: "Get Started",
                onPressed: () {

                  Get.to(() => const StartAssessment(), transition: Transition.noTransition);
                },
                color: AppColors.pGreenColor,
                fontColor: AppColors.pWhiteColor,
                borderRadius: 0,
                size: 18 * autoScale,
                weight: FontWeight.w600,
                removePadding: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
