import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class DiabetesEducationPage extends StatelessWidget {
  const DiabetesEducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mehr zu Diabetes'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Über Diabetes'),
            subtitle: const Text('Grundlegende Informationen zu Diabetes'),
            onTap: () => _launchURL('https://www.diabeteseducator.org'),
          ),
          ListTile(
            title: const Text('Ernährung und Diabetes'),
            subtitle: const Text('Informationen zur Ernährung bei Diabetes'),
            onTap: () => _launchURL('https://www.diabetes.org/nutrition'),
          ),
          // Weitere ListTiles für andere Abschnitte
        ],
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
