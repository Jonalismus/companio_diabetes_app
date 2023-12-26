import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController bmiController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: currentUser.displayName ?? "");
    ageController = TextEditingController(text: "");
    genderController = TextEditingController(text: "");
    bmiController = TextEditingController(text: "");

    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

      setState(() {
        ageController.text = userDoc['age'] ?? "";
        genderController.text = userDoc['gender'] ?? "";
        bmiController.text = userDoc['bmi'] ?? "";
      });
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> updateUserData() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'name': nameController.text,
        'age': ageController.text,
        'gender': genderController.text,
        'bmi': bmiController.text,
      });

      await currentUser.updateDisplayName(nameController.text);
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Profile Screen"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateUserData();
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Age'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: genderController,
            decoration: InputDecoration(labelText: 'Gender'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: bmiController,
            decoration: InputDecoration(labelText: 'BMI'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    bmiController.dispose();
    super.dispose();
  }
}
