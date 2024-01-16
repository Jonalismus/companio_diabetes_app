import 'package:flutter/material.dart';
import '../../utilis/colors_utilis.dart';

class NotfallplanPage extends StatelessWidget {
  const NotfallplanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notfallplan',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("#3158C3"),
              hexStringToColor("#3184C3"),
              hexStringToColor("#551CB4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(
                20.0), // Hier können Sie den gewünschten Abstand anpassen
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Falls es zu einer Über- oder Unterzuckerung kommt, befolgen Sie diese Anweisungen:',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 20),
                const Text(
                  'Schritt 1: Besteht die Gefahr von Bewusstlosigkeit?\n'
                  'Wählen Sie umgehend die Notfallhotline 112 oder 116 117.',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 20),
                const Text(
                  'Schritt 2: Messen Sie Ihren Blutzucker und klären Sie ob es sich um eine Über- oder Unterzuckerung handelt.',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showUnterzuckerungInfo(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(double.infinity, 60.0),
                  ),
                  child: Text('Unterzuckerung'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showUeberzuckerungInfo(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: Size(double.infinity, 60.0),
                  ),
                  child: Text('Überzuckerung'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUnterzuckerungInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unterzuckerung'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  '- Konsumieren Sie etwas Zuckerhaltiges wie zum Beispiel Fruchtsaft oder Traubenzucker'),
              Text('- Verwenden Sie, falls vorhanden, eine Glukagon Spritze'),
              Text(
                  '- Messen Sie den Blutzucker nach 15 min nochmal und beurteilen Sie den Gesundheitszustand'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  }

  void _showUeberzuckerungInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Überzuckerung'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('- Trinken Sie viel Wasser'),
              Text('- Spritzen Sie sich Insulin'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Schließen'),
            ),
          ],
        );
      },
    );
  }
}
