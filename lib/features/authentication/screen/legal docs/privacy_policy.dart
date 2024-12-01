import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';  // Import the markdown package
import 'package:psb_app/utils/reusable_text.dart';
import 'package:psb_app/utils/global_variables.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late Future<Map<String, dynamic>> _privacyData;

  @override
  void initState() {
    super.initState();
    _privacyData = fetchPrivacyPolicy();
  }

  Future<Map<String, dynamic>> fetchPrivacyPolicy() async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('legal_documents')
        .doc('privacy_policy')
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
          text: "Privacy Policy",
        ),
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
        surfaceTintColor: AppColors.pNoColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _privacyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: ReusableText(text: 'Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: ReusableText(text: 'No Privacy Policy available.'));
          }

          var privacy = snapshot.data!;
          List content = privacy['content'];
          String lastUpdate = privacy['last_update'] ?? 'Not Available';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: "Privacy Policy",
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

                            // Check if body is a list or a string
                            if (content[index]['body'] is List)
                            // If body is a list, join it with newlines
                              MarkdownBody(
                                data: (content[index]['body'] as List)
                                    .join('\n'),  // Convert list to newline-separated string
                                styleSheet: MarkdownStyleSheet(
                                  h2: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18 * autoScale),
                                  p: TextStyle(fontFamily: 'Poppins', fontSize: 14 * autoScale, color: Colors.black54),
                                  listBullet: TextStyle(fontFamily: 'Poppins', fontSize: 14 * autoScale),
                                ),
                              ),
                            if (content[index]['body'] is String)
                            // If body is a string, directly use MarkdownBody
                              MarkdownBody(
                                data: content[index]['body'],
                                styleSheet: MarkdownStyleSheet(
                                  h2: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 18 * autoScale),
                                  p: TextStyle(fontFamily: 'Poppins', fontSize: 14 * autoScale, color: Colors.black54),
                                  listBullet: TextStyle(fontFamily: 'Poppins', fontSize: 14 * autoScale),
                                ),
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
                        text: "If you have any questions about this Privacy Policy, please contact us at ",
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
