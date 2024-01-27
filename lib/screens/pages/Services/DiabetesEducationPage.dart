import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utilis/colors_utilis.dart';

class DiabetesEducationPage extends StatelessWidget {
  const DiabetesEducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mehr zu Diabetes'),
      ),
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
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text(
                'Über Diabetes',
                style: TextStyle(color: Colors.white), // Schriftfarbe
              ),
              subtitle: const Text(
                'Grundlegende Informationen zu Diabetes',
                style: TextStyle(color: Colors.white), // Schriftfarbe
              ),
              onTap: () => _launchURL('https://www.diabeteseducator.org'),
            ),
            ListTile(
              title: const Text(
                'Ernährung und Diabetes',
                style: TextStyle(color: Colors.white), // Schriftfarbe
              ),
              subtitle: const Text(
                'Informationen zur Ernährung bei Diabetes',
                style: TextStyle(color: Colors.white), // Schriftfarbe
              ),
              onTap: () => _launchURL('https://www.diabetes.org/nutrition'),
            ),
            // Weitere ListTiles für andere Abschnitte
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
