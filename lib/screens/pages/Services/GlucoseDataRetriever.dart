import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlucoseData {
  final DateTime dateTime;
  final double glucoseLevel;

  GlucoseData(this.dateTime, this.glucoseLevel);
}

class GlucoseDataRetriever {
  static User? _currentUser = FirebaseAuth.instance.currentUser;

  GlucoseDataRetriever();

  static Future<List<GlucoseData>> getGlucoseDataLast7Days() async {
    List<GlucoseData> glucoseDataList = [];
    final currentUser = _currentUser;

    if (currentUser != null) {
      DateTime now = DateTime.now();
      DateTime sevenDaysAgo = now.subtract(Duration(days: 7));

      CollectionReference readingsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('blood_glucose_readings');

      QuerySnapshot querySnapshot = await readingsCollection
          .where('date_time', isGreaterThanOrEqualTo: sevenDaysAgo)
          .orderBy('date_time', descending: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          DateTime dateTime = (documentSnapshot['date_time'] as Timestamp)
              .toDate();
          double glucoseLevel = documentSnapshot['glucose_level'];

          glucoseDataList.add(GlucoseData(dateTime, glucoseLevel));
        }
      } else {
        print('No glucose readings found in the last 7 days');
      }
    }

    return glucoseDataList;
  }

//retrives the last stored glycose value out of firebase
  static Future<double> readLastGlucoseValue() async {
    double lastGlucoseValue = 0;
    final currentUser = _currentUser;

    if (currentUser != null) {
      CollectionReference readingsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('blood_glucose_readings');

      QuerySnapshot querySnapshot = await readingsCollection
          .orderBy('date_time', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Retrieve the first document (most recent)
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Access the 'glucose_level' field from the document
        lastGlucoseValue = documentSnapshot['glucose_level'];
      } else {
        throw Exception('No glucose readings found');
      }
    }
    return lastGlucoseValue;
  }

  static Future<List<GlucoseData>> getGlucoseDataForLastDay() async {
    List<GlucoseData> glucoseDataList = [];

    final currentUser = _currentUser;
    if (currentUser != null) {
      DateTime now = DateTime.now();
      DateTime yesterday = now.subtract(Duration(days: 1));

      CollectionReference readingsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('blood_glucose_readings');

      QuerySnapshot querySnapshot = await readingsCollection
          .where('date_time', isGreaterThanOrEqualTo: yesterday)
          .orderBy('date_time', descending: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          DateTime dateTime = (documentSnapshot['date_time'] as Timestamp)
              .toDate();
          double glucoseLevel = documentSnapshot['glucose_level'];

          glucoseDataList.add(GlucoseData(dateTime, glucoseLevel));
        }
      } else {
        print('No glucose readings found for the last day');
      }
    }
    return glucoseDataList;
  }
}