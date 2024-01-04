import 'package:companio_diabetes_app/screens/pages/Insulinrechner.dart';
import 'package:companio_diabetes_app/screens/pages/sugarIntakeOverview.dart';
import 'package:companio_diabetes_app/screens/pages/blutzuckermessung.dart';
import 'package:companio_diabetes_app/screens/pages/bloodsugar_overview_dashboard.dart';
import 'package:companio_diabetes_app/screens/pages/fooddairy.dart';
import 'package:companio_diabetes_app/screens/pages/home.dart';
import 'package:companio_diabetes_app/screens/pages/notfallplan.dart';
import 'package:companio_diabetes_app/screens/pages/stepCounterPage.dart';
import 'package:companio_diabetes_app/datenbank/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:companio_diabetes_app/screens/pages/notificationSettings.dart';
import 'package:companio_diabetes_app/screens/pages/settings.dart';
import 'package:provider/provider.dart';

import '../utilis/dao/loadData.dart';


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

  void _navigateToSugarIntakeOverviewPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  ChangeNotifierProvider(
            create: (context) => DataProvider()..loadData(),
            child: SugarIntakeOverview(),
          ),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Companio'),
      // ),
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
                        MaterialPageRoute(builder: (context) => BloodsugarOverview()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('BlutzuckerOverview '),
                  ),
                ),
                const SizedBox(height: 2),
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
                const SizedBox(height:2),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Insulinrechner()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Insulinrechner'),
                  ),
                ),
                const SizedBox(height: 2),
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
                const SizedBox(height: 2),
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
                const SizedBox(height: 2),
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
                const SizedBox(height: 2),
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToSugarIntakeOverviewPage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Zuckeraufnahmenübersicht'),
                  ),
                ),
              ],
            ),
    );
  }
}

