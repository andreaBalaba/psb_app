import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addFood(dynamic json1) async {
  final docUser = FirebaseFirestore.instance.collection('Foods').doc();

  final json = json1;

  await docUser.set(json);
}
