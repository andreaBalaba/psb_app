import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_app/features/home/screen/equipment_page.dart';
import 'package:psb_app/features/library/controller/library_controller.dart';
import 'package:psb_app/utils/global_variables.dart';
import 'package:psb_app/utils/reusable_text.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with AutomaticKeepAliveClientMixin {
  final LibraryController controller = Get.put(LibraryController());
  bool _showShadow = false; // Local variable to track shadow status

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
    double autoScale = Get.width / 360;

    return Scaffold(
        backgroundColor: AppColors.pBGWhiteColor,
        appBar: AppBar(
          title: ReusableText(
            text: 'Equipment Library',
            fontWeight: FontWeight.bold,
            size: 20 * autoScale,
          ),
          backgroundColor: AppColors.pBGWhiteColor,
          elevation: _showShadow ? 6.0 : 0.0,
          shadowColor: Colors.black26,
          surfaceTintColor: AppColors.pNoColor,
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Equipments')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(child: Text('Error'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                );
              }

              final data = snapshot.requireData;
              return ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0 * autoScale,
                  vertical: 8.0 * autoScale,
                ),
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  final equipment = data.docs[index]['data'];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0 * autoScale),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => EquipmentPage(
                              isName: equipment['exercise'] == null,
                              data: equipment['exercise'] ?? equipment['name'],
                            ));
                        // Get.to(() => EquipmentDetailsPage(
                        //       imagePath: equipment.imagePath,
                        //       name: equipment.name,
                        //       level: equipment.experienceLevel,
                        //       duration: equipment.duration,
                        //       calories: equipment.calories,
                        //       description: equipment.description,
                        //     ));
                      },
                      child: Container(
                        height: 120 * autoScale,
                        decoration: BoxDecoration(
                          color: controller.getCategoryColor('Leg Equipment'),
                          borderRadius: BorderRadius.circular(12.0 * autoScale),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3 * autoScale,
                              offset: Offset(0, 3 * autoScale),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5 * autoScale),
                            Padding(
                              padding: EdgeInsets.all(8.0 * autoScale),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(8.0 * autoScale),
                                child: Image.network(
                                  equipment['image'],
                                  width: 80 * autoScale,
                                  height: 80 * autoScale,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 5 * autoScale),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: 8.0 * autoScale,
                                    top: 16 * autoScale,
                                    bottom: 16 * autoScale),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ReusableText(
                                      text: equipment['exercise'] ??
                                          equipment['name'],
                                      fontWeight: FontWeight.bold,
                                      size: 18.0 * autoScale,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4 * autoScale),
                                    ReusableText(
                                      text: 'See details',
                                      color: AppColors.pBlack87Color,
                                      size: 12.0 * autoScale,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
