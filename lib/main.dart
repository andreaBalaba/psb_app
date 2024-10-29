import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/splash/screen/splash_page.dart';
import 'package:psb_app/utils/global_variables.dart';


void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PulseStrength',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.pWhiteColor)
      ),
      home: const SplashPage(),
    );
  }
}

