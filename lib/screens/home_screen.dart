import 'package:flutter/material.dart';
import 'package:companio_diabetes_app/screens/pages/Insulinrechner.dart';
import 'package:companio_diabetes_app/screens/pages/blutzuckermessung.dart';
import 'package:companio_diabetes_app/screens/pages/bloodsugar_overview_dashboard.dart';
import 'package:companio_diabetes_app/screens/pages/fooddairy.dart';
import 'package:companio_diabetes_app/screens/pages/home.dart';
import 'package:companio_diabetes_app/screens/pages/notfallplan.dart';
import 'package:companio_diabetes_app/screens/pages/stepCounterPage.dart';
import 'package:companio_diabetes_app/datenbank/firestore_controller.dart';
import 'package:companio_diabetes_app/screens/pages/notificationSettings.dart';
import 'package:companio_diabetes_app/screens/pages/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final FirebaseController _firebaseController = FirebaseController();

  final List<Widget> _pages = [
    const NotfallplanPage(),
    const HomePage(),
    const FoodDairyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() async {
    await _firebaseController.checkAndCreateUserDocument();
  }

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
        ),
      ),
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
      MaterialPageRoute(builder: (context) => const StepCounterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            _pages[_selectedIndex],
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Companio'),
        actions: [
          Align(
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
          : Padding(
        padding: const EdgeInsets.only(left: 32),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BloodsugarOverview()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(double.infinity, 60.0),
                  ),
                  child: const Text(
                    'BlutzuckerOverview',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlutzuckermessungPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(double.infinity, 60.0),
                  ),
                  child: const Text(
                    'Blutzuckermessung',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Insulinrechner()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(double.infinity, 60.0),
                  ),
                  child: const Text(
                    'Insulinrechner',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _navigateToNotificationSettings,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(double.infinity, 60.0),
                  ),
                  child: const Text(
                    'Medikamenten-Erinnerung',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _navigateToStepCounterPage,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(double.infinity, 60.0),
                  ),
                  child: const Text(
                    'Schrittzähler',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
