import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//retrives the last stored glycose value out of firebase
Future<double> readLastGlucoseValue() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  double glucoseLevel = 0;

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
      glucoseLevel = documentSnapshot['glucose_level'];
    } else {
      throw Exception('No glucose readings found');
    }
  }
  return glucoseLevel;
}