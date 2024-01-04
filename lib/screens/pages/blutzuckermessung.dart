import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlutzuckermessungPage extends StatefulWidget {
  const BlutzuckermessungPage({Key? key}) : super(key: key);

  @override
  _BlutzuckermessungPageState createState() => _BlutzuckermessungPageState();
}

class _BlutzuckermessungPageState extends State<BlutzuckermessungPage> {
  TextEditingController _controller = TextEditingController();
  String _warningMessage = '';

  void _checkBloodSugar() async {
    if (_controller.text.isEmpty) {
      setState(() {
        _warningMessage = 'Bitte geben Sie einen Blutwert ein.';
      });
      return;
    }

    double bloodSugarValue = double.tryParse(_controller.text) ?? 0;

    if (bloodSugarValue < 50) {
      setState(() {
        _warningMessage = 'Achtung unterzuckert!';
      });
    } else if (bloodSugarValue > 250) {
      setState(() {
        _warningMessage = 'Achtung überzuckert!';
      });
    } else {
      setState(() {
        _warningMessage = 'Blutwert im normalen Bereich';
      });
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
        'glucose_level': bloodSugarValue,
        'date_time': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blutzuckermessung'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Blutwert (mg/dl)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkBloodSugar,
              child: const Text('Blutwert überprüfen'),
            ),
            const SizedBox(height: 16),
            Text(
              _warningMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
