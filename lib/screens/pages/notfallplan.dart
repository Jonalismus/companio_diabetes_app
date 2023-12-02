import 'package:flutter/material.dart';

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Falls es zu einer Über- oder Unterzuckerung kommt, befolgen Sie diese Anweisungen:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Schritt 1: Besteht die Gefahr von Bewusstlosigkeit?\n'
                  'In diesem Fall wählen Sie bitte umgehend die Notfallhotline 112 oder 116 117.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('Schritt 2: Messen Sie Ihren Blutzucker.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('Schritt 3: Klären Sie, ob es sich um eine Über- oder Unterzuckerung handelt.',
              style: TextStyle(fontSize: 20),
            ),
            Text('Unterzuckerung:\n'
                '- Konsumieren Sie etwas Zuckerhaltiges wie zum Beispiel Fruchtsaft oder Traubenzucker \n'
                '- Verwenden Sie, falls vorhanden, eine Glukagon Spritze\n'
                '- Messen Sie den Blutzucker nach 15 min nochmal und beurteilen Sie den Gesundheitszustand',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('Überzuckerung:\n'
                '- Trinken Sie viel Wasser\n'
                '- Spritzen Sie sich Insulin',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
