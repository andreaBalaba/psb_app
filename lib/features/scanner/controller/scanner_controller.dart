import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:psb_app/api/services/add_equipment.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ScannerController extends GetxController {
  CameraController? cameraController;
  var isCameraInitialized = false.obs;
  var recognitionLabel = "".obs;
  bool isDetecting = false;
  bool isPaused = false;

  // Preload camera during app launch, pausing the stream afterward
  Future<void> preloadCamera() async {
    if (cameraController == null) {
      await initializeCamera();
      pauseImageStream(); // Pause the image stream after preloading
    }
  }

  // Initialize the camera with error handling
  Future<void> initializeCamera() async {
    if (cameraController == null) {
      try {
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          cameraController = CameraController(cameras[0], ResolutionPreset.max);
          await cameraController!.initialize();
          isCameraInitialized.value = true;
          await loadTfliteModel();
        } else {
          print("No cameras found on device.");
        }
      } catch (e) {
        print("Error initializing camera: $e");
      }
    }
  }

  // Load the TFLite model with error handling
  Future<void> loadTfliteModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/ml/model_unquant.tflite",
        labels: "assets/ml/labels.txt",
      );
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading TFLite model: $e");
    }
  }

  // Start the image stream if the camera is ready and not paused, with error checks
  void startImageStream() {
    if (cameraController != null &&
        isCameraInitialized.value &&
        !cameraController!.value.isStreamingImages &&
        !isPaused) {
      try {
        cameraController!.startImageStream((CameraImage img) async {
          if (!isDetecting) {
            isDetecting = true;
            try {
              final recognitions = await Tflite.runModelOnFrame(
                bytesList: img.planes.map((plane) => plane.bytes).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 1,
              );

              if (recognitions != null && recognitions.isNotEmpty) {
                if (recognitions[0]['confidence'] > 0.85) {
                  recognitionLabel.value = recognitions[0]['label'];

                  Get.dialog(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Material(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      "Detected: ${recognitions[0]['label']}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      "Do you want to save this equipment in the library?",
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    //Buttons
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(0, 45),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text(
                                              'NO',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(0, 45),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () async {
                                              String jsonString =
                                                  await rootBundle.loadString(
                                                      'assets/images/Gym-equipments-Datas.json');

                                              Map<String, dynamic> jsonData =
                                                  jsonDecode(jsonString);

                                              List equipments =
                                                  jsonData['equipment'];

                                              addEquipment(
                                                  equipments.where(
                                                    (element) {
                                                      return element['name'] ==
                                                          recognitions[0]
                                                              ['label'];
                                                    },
                                                  ).first,
                                                  recognitions[0]['label']);
                                              Get.back();
                                            },
                                            child: const Text(
                                              'YES',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  recognitionLabel.value = "No equipment detected";
                }
              } else {
                recognitionLabel.value = "No equipment detected";
              }
            } catch (e) {
              print("Error during image processing: $e");
            } finally {
              isDetecting = false;
            }
          }
        });
      } catch (e) {
        print("Error starting image stream: $e");
      }
    } else {
      print("Camera not ready, already streaming, or paused.");
    }
  }

  // Pause the image stream
  void pauseImageStream() {
    if (cameraController != null && cameraController!.value.isStreamingImages) {
      try {
        cameraController!.stopImageStream();
        isDetecting = false;
        isPaused = true;
        print("Image stream paused");
      } catch (e) {
        print("Error pausing image stream: $e");
      }
    }
  }

  // Resume the image stream if it was paused
  void resumeImageStream() {
    if (isPaused && cameraController != null) {
      isPaused = false;
      startImageStream();
      print("Image stream resumed");
    }
  }

  // Stop the image stream safely
  void stopImageStream() {
    if (cameraController != null && cameraController!.value.isStreamingImages) {
      try {
        cameraController!.stopImageStream();
        isDetecting = false;
        isPaused = false;
        print("Image stream stopped");
      } catch (e) {
        print("Error stopping image stream: $e");
      }
    }
  }

  // Release camera and resources explicitly
  void releaseCameraResources() {
    stopImageStream();
    cameraController?.dispose();
    cameraController = null;
    Tflite.close();
    print("Camera and model resources released");
  }

  @override
  void onReady() {
    resumeImageStream(); // Resume the stream when the scanner is ready
    super.onReady();
  }

  @override
  void onClose() {
    releaseCameraResources();
    super.onClose();
  }

  @override
  void dispose() {
    releaseCameraResources();
    super.dispose();
  }
}
