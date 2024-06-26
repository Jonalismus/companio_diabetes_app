import 'package:companio_diabetes_app/api/notification_api.dart';
import 'package:companio_diabetes_app/firebase_options.dart';
import 'package:companio_diabetes_app/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi().initNotification();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    //Für die Webanwendung:
   options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutterApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(), // Entfernen Sie 'const' hier
    );
  }
}

