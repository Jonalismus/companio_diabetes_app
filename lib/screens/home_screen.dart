import 'package:companio_diabetes_app/screens/pages/fooddairy.dart';
import 'package:companio_diabetes_app/screens/pages/home.dart';
import 'package:companio_diabetes_app/screens/pages/notfallplan.dart';
import 'package:companio_diabetes_app/screens/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:companio_diabetes_app/datenbank/firestore_controller.dart';

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

  final FirebaseController _firebaseController = FirebaseController();

  @override
  void initState() {
    super.initState();
    // Check and create user document when the screen initializes
    _checkAndCreateUserDocument();
  }

  void _checkAndCreateUserDocument() async {
    try {
      await _firebaseController.checkAndCreateUserDocument();
    } catch (e) {
      // Handle errors, e.g., show a snackbar or log the error
      print('Error checking and creating user document: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Companio'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality here
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
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
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Implement the functionality for Blutzuckermessung here.
              },
              child: Text('Blutzuckermessung'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Implement the functionality for Insulinrechner here.
              },
              child: Text('Insulinrechner'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
