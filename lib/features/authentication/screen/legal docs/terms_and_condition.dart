import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:psb_app/utils/reusable_text.dart';
import 'package:psb_app/utils/global_variables.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  late Future<Map<String, dynamic>> _termsData;

  @override
  void initState() {
    super.initState();
    _termsData = fetchTermsAndConditions();
  }

  Future<Map<String, dynamic>> fetchTermsAndConditions() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('legal_documents')
        .doc('terms_and_conditions')
        .get();

    var data = documentSnapshot.data() as Map<String, dynamic>;

    if (data['last_update'] is Timestamp) {
      Timestamp timestamp = data['last_update'];
      DateTime dateTime = timestamp.toDate();
      String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
      data['last_update'] = formattedDate;
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    double autoScale = Get.width / 360;

    return Scaffold(
      backgroundColor: AppColors.pBGWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.pBGWhiteColor,
        title: const ReusableText(
          text: "Terms and Conditions",
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        surfaceTintColor: AppColors.pNoColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _termsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: ReusableText(text: 'Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: ReusableText(text: 'No Terms and Conditions available.'));
          }

          var terms = snapshot.data!;
          List content = terms['content'];
          String lastUpdate = terms['last_update'] ?? 'Not Available';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: "Terms and Conditions",
                  fontWeight: FontWeight.bold,
                  size: 28 * autoScale,
                ),
                const SizedBox(height: 10),
                ReusableText(
                  text: 'Effective Date:  $lastUpdate',
                  fontWeight: FontWeight.bold,
                  size: 18 * autoScale,
                  color: AppColors.pDarkGreyColor,
                ),
                const SizedBox(height: 20),

                // Display content with modern card design
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppColors.pBGWhiteColor,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: content[index]['title'],
                              fontWeight: FontWeight.bold,
                              size: 20 * autoScale,
                              color: Colors.black87,
                            ),
                            const SizedBox(height: 10),
                            ReusableText(
                              text: content[index]['body'],
                              size: 14 * autoScale,
                              color: Colors.black54,
                              align: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Footer with simple contact info
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      ReusableText(
                        text: "For any questions or concerns, please contact us at",
                        size: 14 * autoScale,
                        color: Colors.black54,
                        align: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ReusableText(
                        text: "pulsestrength@gmail.com",
                        fontWeight: FontWeight.bold,
                        size: 16 * autoScale,
                        color: AppColors.pSOrangeColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
