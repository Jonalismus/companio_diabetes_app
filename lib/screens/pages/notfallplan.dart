import 'package:flutter/material.dart';

class NotfallplanPage extends StatelessWidget {
  const NotfallplanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notfallplan'),
      ),
      body: const Center(
        child: Text(
          'Hier ist dein Notfallplan!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
