import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addEquipment(Map<String, dynamic> data, name) async {
  final docUser = FirebaseFirestore.instance.collection('Equipments').doc(name);

  final json = {
    'data': data,
    'uid': FirebaseAuth.instance.currentUser!.uid,
  };

  await docUser.set(json);

  return json;
}
