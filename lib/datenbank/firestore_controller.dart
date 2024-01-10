import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkAndCreateUserDocument() async {
    // Get the current user
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Reference to the user document using the UID as the document ID
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      // Check if the user document exists
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (!docSnapshot.exists) {
        // If the document doesn't exist, create a new one with subcollections
        await userDocRef.set({
          'blood_glucose_readings': [],
          'medication_logs': [],
          'meal_logs': [],
          'insulin_recommendations': [],
        });
      } else {
        // If the document exists, update it with the specified fields
        await userDocRef.update({
          'blood_glucose_readings': FieldValue.arrayUnion([]),
          'medication_logs': FieldValue.arrayUnion([]),
          'meal_logs': FieldValue.arrayUnion([]),
          'insulin_recommendations': FieldValue.arrayUnion([])
        });
      }
    }
  }
}
