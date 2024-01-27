import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodSugarManager {
  late Timer _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isRunning = false;

  // Singleton instance
  static final BloodSugarManager _instance = BloodSugarManager._internal();

  // Private constructor
  BloodSugarManager._internal();

  // Getter for the singleton instance
  static BloodSugarManager get instance => _instance;

  void startSimulation() {
    if (!_isRunning) {
      _timer = Timer.periodic(Duration(seconds: 60), (Timer timer) async {
        User? currentUser = _auth.currentUser;

        if (currentUser != null) {
          CollectionReference readingsCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .collection('blood_glucose_readings');

          double randomBloodSugarValue = 50 + (200 * (DateTime.now().microsecondsSinceEpoch % 1000) / 1000);

          await readingsCollection.add({
            'glucose_level': randomBloodSugarValue,
            'date_time': Timestamp.now(),
          });

          print('Simulated Blood Sugar Value: $randomBloodSugarValue');
        }
      });

      _isRunning = true;
    }
  }

  void stopSimulation() {
    if (_isRunning && _timer != null && _timer.isActive) {
      _timer.cancel();
    }
    _isRunning = false;
  }


  bool get isRunning => _isRunning;
}
