import 'package:flutter/material.dart';
import '../profilScreen.dart';
import 'Services/DiabetesEducationPage.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  void _logout() {
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
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Center(
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
                  MaterialPageRoute(builder: (context) => const DiabetesEducationPage()),
                );
              },
              child: const Text('Mehr über Diabetes erfahren'),
            ),
            const SizedBox(height: 20), // Fügt 20 Pixel Abstand hinzu
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
    );
  }
}
