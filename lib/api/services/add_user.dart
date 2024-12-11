import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addUser(name, email) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'email': email,
    'id': docUser.id,
    'isVerified': false,
    'isActive': true,
    'uid': FirebaseAuth.instance.currentUser!.uid,
    'workouts': [],
    'sleep': 0,
    'water': 0,
    'notif': false,
    'warmup': false,
    'stretching': false,
    'height': 0,
    'weight': 0,
    'age': 0,
    'bmi': 0,
    'gender': '',
    'calories': 0,
    'steps': 0,
  };

  await docUser.set(json);
}
