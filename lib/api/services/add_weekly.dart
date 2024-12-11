import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addWeekly() async {
  final docUser = FirebaseFirestore.instance
      .collection('Weekly')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    '1': {
      'workouts': 0,
      'steps': 0,
      'water': 0,
      'sleep': 0,
      'calories': 0,
      'mins': 0,
    },
    '2': {
      'workouts': 0,
      'steps': 0,
      'water': 0,
      'sleep': 0,
      'calories': 0,
      'mins': 0,
    },
    '3': {
      'workouts': 0,
      'steps': 0,
      'water': 0,
      'sleep': 0,
      'calories': 0,
      'mins': 0,
    },
    '4': {
      'workouts': 0,
      'steps': 0,
      'water': 0,
      'sleep': 0,
      'calories': 0,
      'mins': 0,
    },
    '5': {
      'workouts': 0,
      'steps': 0,
      'water': 0,
      'sleep': 0,
      'calories': 0,
      'mins': 0,
    },
    '6': {
      'workouts': 0,
      'steps': 0,
      'water': 0,
      'sleep': 0,
      'calories': 0,
      'mins': 0,
    },
    '7': {
      'workouts': 0,
      'steps': 0,
      'water': 0,
      'sleep': 0,
      'calories': 0,
      'mins': 0,
    },
    'uid': FirebaseAuth.instance.currentUser!.uid,
    'dateTime': DateTime.now(),
    'year': DateTime.now().year,
    'month': DateTime.now().month,
    'day': DateTime.now().day,
  };

  await docUser.set(json);

  return json;
}
