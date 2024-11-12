import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addDailyPlan() async {
  final docUser = FirebaseFirestore.instance.collection('Daily Plan').doc();

  final json = {
    'day': DateTime.now().day,
    'month': DateTime.now().month,
    'year': DateTime.now().year,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'workouts': [],
    'calories': 0,
    'steps': 0,
    'water': 0,
    'sleep': 0,
    'week': DateTime.now().weekday,
    'id': docUser.id,
  };

  await docUser.set(json);

  return json;
}
