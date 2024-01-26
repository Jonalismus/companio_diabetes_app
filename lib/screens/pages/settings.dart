import 'package:flutter/material.dart';
import '../../utilis/colors_utilis.dart';
import '../profilScreen.dart';
import 'FeedbackScreen.dart';
import 'Services/DiabetesEducationPage.dart';
import 'package:companio_diabetes_app/datenbank/BloodSugarManager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  void _logout() {
    BloodSugarManager.instance.stopSimulation();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    hexStringToColor("#3158C3"),
    hexStringToColor("#3184C3"),
    hexStringToColor("#551CB4"),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _navigateToProfile,
              child: const Text('Mein Profil'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  FeedbackScreen()),
                );
              },
              child: const Text('Feedback'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiabetesEducationPage()),
                );
              },
              child: const Text('Mehr über Diabetes erfahren'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
