import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

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

  void startSimulation() async {
    if (!_isRunning) {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String csvContent = await File('/simdata/dummydata.csv').readAsString();
        List<List<dynamic>> csvList = CsvToListConverter().convert(csvContent);

        _timer = Timer.periodic(Duration(minutes: 5), (Timer timer) async {
          int randomRowIndex = Random().nextInt(csvList.length);

          double glucoseValue = csvList[randomRowIndex][7];

          CollectionReference readingsCollection = FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .collection('blood_glucose_readings');

          await readingsCollection.add({
            'glucose_level': glucoseValue,
            'date_time': Timestamp.now(),
          });

          print('Simulated Blood Sugar Value: $glucoseValue');
        });

        _isRunning = true;
      }
    }
  }

  void stopSimulation() {
    _timer.cancel();
    _isRunning = false;
  }

  bool get isRunning => _isRunning;
}
