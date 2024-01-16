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
        // If the document doesn't exist, create a new one
        await userDocRef.set({});
      }

      // Check and create subcollections individually
      await _checkAndCreateSubcollection(userDocRef, 'blood_glucose_readings');
      await _checkAndCreateSubcollection(userDocRef, 'medication_logs');
      await _checkAndCreateSubcollection(userDocRef, 'meal_logs');
      await _checkAndCreateSubcollection(userDocRef, 'insulin_recommendations');
    }
  }

  Future<void> _checkAndCreateSubcollection(
      DocumentReference userDocRef, String subcollectionName) async {
    CollectionReference subcollectionRef = userDocRef.collection(subcollectionName);

    QuerySnapshot subcollectionSnapshot = await subcollectionRef.get();

    if (subcollectionSnapshot.docs.isEmpty) {
      // Subcollection doesn't exist, create it
      await subcollectionRef.add({});
    }
  }
}
