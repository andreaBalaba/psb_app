import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psb_app/features/home/screen/home_page.dart';
import 'package:psb_app/features/scanner/controller/scanner_controller.dart';
import 'package:psb_app/features/splash/screen/splash_page.dart';
import 'package:psb_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await requestActivityRecognitionPermission();

  final scannerController = Get.put(ScannerController()); //temporary
  await scannerController.preloadCamera(); //temporary
  await Firebase.initializeApp(
    name: 'psbapp-32784',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// Request activity recognition permission and show dialog if denied
Future<void> requestActivityRecognitionPermission() async {
  PermissionStatus status = await Permission.activityRecognition.request();

  if (status.isDenied) {
    // Show dialog if permission is denied
    Get.dialog(
      AlertDialog(
        title: const Text('Activity Recognition Permission'),
        content: const Text(
          'This app needs activity recognition permission to function correctly.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Deny'),
            onPressed: () {
              Get.back(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Settings'),
            onPressed: () {
              openAppSettings(); // Open app settings
              Get.back(); // Close the dialog
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PulseStrength',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const SplashPage();
            }
          }),
    );
  }
}
