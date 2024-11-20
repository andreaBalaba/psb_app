import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:psb_app/features/meal/screen/widget/search_bar_widget.dart';
import 'package:psb_app/features/settings/screen/setting_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:psb_app/utils/textfield_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class AddMealPage extends StatefulWidget {
  dynamic data;

  AddMealPage({super.key, required this.data});
  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  List data = [
    {
      'name': 'Calories',
      'data': '300g',
      'color': Colors.green,
    },
    {
      'name': 'Carbs',
      'data': '10g',
      'color': Colors.blue,
    },
    {
      'name': 'Fats',
      'data': '30g',
      'color': Colors.purple,
    },
    {
      'name': 'Protein',
      'data': '40g',
      'color': Colors.orange,
    }
  ];

  List facts1 = [
    {
      'name': 'Fat',
      'data': '0g',
      'color': Colors.green,
    },
    {
      'name': 'Sodium',
      'data': '0g',
      'color': Colors.blue,
    },
    {
      'name': 'Cholesterol ',
      'data': '0g',
      'color': Colors.purple,
    },
  ];

  List facts2 = [
    {
      'name': 'Sugar',
      'data': '0g',
      'color': Colors.green,
    },
    {
      'name': 'Fiber',
      'data': '0g',
      'color': Colors.blue,
    },
    {
      'name': 'Carbohydrates  ',
      'data': '0g',
      'color': Colors.purple,
    },
  ];
  int fat = 0;
  int sodium = 0;
  int cholesterol = 0;
  int sugar = 0;
  int fiber = 0;
  int carbs = 0;
  final mealName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        elevation: 4.0,
        surfaceTintColor: AppColors.pNoColor,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Image.asset(
                  IconAssets.pChatBotIcon,
                  height: 30,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  IconAssets.pSettingIcon,
                  height: 30,
                ),
                onPressed: () {
                  Get.to(() => const SettingsPage(),
                      transition: Transition.rightToLeft);
                },
              ),
              const SizedBox(width: 2.0),
            ],
          ),
        ],
        title: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage(IconAssets.pUserIcon),
                radius: 20,
              ),
              const SizedBox(width: 8.0),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading'));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    dynamic data = snapshot.data;
                    return Flexible(
                      child: ReusableText(
                        text: data['name'],
                        size: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.pBlackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: ReusableText(
                text: 'Add Food',
                size: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.pBlackColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 65,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ReusableText(
                      text: widget.data['name'],
                      size: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pBlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Container(
                    height: 251,
                    width: 208,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.data['img'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReusableText(
                      text: 'Serving Size',
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.pBlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 150,
                        height: 35,
                        child: TextField(
                          controller: TextEditingController(
                              text: widget.data['servingSize'].toString()),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    const ReusableText(
                      text: 'Number of servings ',
                      size: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.pBlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 150,
                        height: 35,
                        child: TextField(
                          controller: TextEditingController(
                              text: widget.data['numberOfServings'].toString()),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < data.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ReusableText(
                        text: data[i]['name'],
                        size: 12,
                        fontWeight: FontWeight.w400,
                        color: data[i]['color'] ?? Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ReusableText(
                        text:
                            '${i == 0 ? widget.data['calories'] : i == 1 ? widget.data['carbs'] : i == 2 ? widget.data['fats'] : widget.data['protein']}g',
                        size: 12,
                        fontWeight: FontWeight.w400,
                        color: data[i]['color'] ?? Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.grey[300],
              child: const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ReusableText(
                      text: 'Nutrition Facts ',
                      size: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pBlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < facts1.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            // showInput(i == 0
                            //     ? fat
                            //     : i == 1
                            //         ? sodium
                            //         : i == 2
                            //             ? cholesterol
                            //             : i == 3
                            //                 ? sugar
                            //                 : i == 4
                            //                     ? fiber
                            //                     : carbs);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ReusableText(
                                text: facts1[i]['name'],
                                size: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ReusableText(
                                text:
                                    '${i == 0 ? widget.data['fats'] : i == 1 ? widget.data['sodium'] : i == 2 ? widget.data['cholesterol'] : i == 3 ? widget.data['sugar'] : i == 4 ? widget.data['fiber'] : widget.data['carbs']}g',
                                size: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                const SizedBox(height: 75, child: VerticalDivider()),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < facts2.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: facts2[i]['name'],
                              size: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ReusableText(
                              text:
                                  '${i == 0 ? widget.data['sugar'] : i == 1 ? widget.data['fiber'] : i == 2 ? widget.data['carbs'] : i == 3 ? widget.data['sugar'] : i == 4 ? widget.data['fiber'] : widget.data['carbs']}g',
                              size: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Loading . . .',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'),
                ),
              ],
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Pictures/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Pictures/$fileName')
            .getDownloadURL();

        setState(() {});

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  void showInput(int currentValue) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        int tempValue =
            currentValue; // Temporary value to hold the current selection
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 250,
              width: double.infinity,
              child: Column(
                children: [
                  NumberPicker(
                    value: tempValue,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) {
                      setModalState(
                          () => tempValue = value); // Update the modal's state
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentValue = tempValue; // Update the parent state
                      });

                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
