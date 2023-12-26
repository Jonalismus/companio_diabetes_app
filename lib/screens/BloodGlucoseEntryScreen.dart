import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodGlucoseEntryScreen extends StatefulWidget {
  @override
  _BloodGlucoseEntryScreenState createState() =>
      _BloodGlucoseEntryScreenState();
}

class _BloodGlucoseEntryScreenState extends State<BloodGlucoseEntryScreen> {
  final TextEditingController glucoseLevelController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Reference to the user's blood_glucose_readings subcollection
      CollectionReference readingsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('blood_glucose_readings');

      // Add a new document with the entered glucose reading
      await readingsCollection.add({
        'glucose_level': double.parse(glucoseLevelController.text),
        'date_time': Timestamp.now(),
      });

      // Optional: Show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blood glucose reading added successfully!')),
      );

      // Clear the text field
      glucoseLevelController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Glucose Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: glucoseLevelController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid glucose level';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Glucose Level'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
