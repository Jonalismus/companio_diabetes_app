import 'package:companio_diabetes_app/screens/pages/blutzuckermessung.dart';
import 'package:companio_diabetes_app/screens/pages/fooddairy.dart';
import 'package:companio_diabetes_app/screens/pages/home.dart';
import 'package:companio_diabetes_app/screens/pages/notfallplan.dart';
import 'package:companio_diabetes_app/screens/pages/stepCounterPage.dart';
import 'package:flutter/material.dart';
import 'package:companio_diabetes_app/screens/pages/notificationSettings.dart';
import 'package:companio_diabetes_app/screens/pages/settings.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const NotfallplanPage(),
    const HomePage(),
    const FoodDairyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToNotificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const NotificationSettings(
                title: '',
              )),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),

    );
  }

  void _navigateToStepCounterPage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StepCounterPage())
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Companio'),
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            top: 20,
            right : 20,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _navigateToSettings,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Notfallplan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Ernährungstagebuch',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 2 || _selectedIndex == 0
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BlutzuckermessungPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Blutzuckermessung'),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implementiere die Funktionalität für Insulinrechner hier.
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Insulinrechner'),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FoodDairyPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Ernährungstagebuch'),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToNotificationSettings,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Medikamenten-Erinnerung'),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToStepCounterPage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Schrittzähler'),
                  ),
                ),
              ],
            ),
    );
  }
}

