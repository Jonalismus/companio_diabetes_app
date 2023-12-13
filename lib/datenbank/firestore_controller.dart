import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkAndCreateUserDocument() async {
    // Get the current user
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Reference to the user document in the 'users' collection
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      // Check if the document exists
      DocumentSnapshot docSnapshot = await userDocRef.get();

      if (!docSnapshot.exists) {
        // If the document doesn't exist, create a new one
        await userDocRef.set({
          'uid': currentUser.uid,
        });
      }
    }
  }
}
