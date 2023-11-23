import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  static final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  static Future<void> addUser(String name, String email) async {
    try {
      await _usersCollection.add({
        'name': name,
        'email': email,
      });
      print('User added to Firestore');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  static Future<List<Map<String, dynamic>>?> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error retrieving users from Firestore: $e');
      return null;
    }
  }
}