import 'package:flutter/material.dart';

class NotfallplanPage extends StatelessWidget {
  const NotfallplanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notfallplan'),
      ),
      body: Center(
        child: Text(
          'Hier ist dein Notfallplan!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
