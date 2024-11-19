import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/meal/screen/widget/search_bar_widget.dart';
import 'package:psb_app/features/settings/screen/setting_page.dart';
import 'package:psb_app/utils/global_assets.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

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
              height: 50,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ReusableText(
                      text: 'Ginisang monggo',
                      size: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pBlackColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                      onPressed: () {},
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
                Container(
                  height: 251,
                  width: 208,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
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
                        width: 80,
                        height: 35,
                        child: const TextField()),
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
                        width: 80,
                        height: 35,
                        child: const TextField()),
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
                        text: data[i]['data'],
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
                              text: facts1[i]['data'],
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
                              text: facts2[i]['data'],
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
}
