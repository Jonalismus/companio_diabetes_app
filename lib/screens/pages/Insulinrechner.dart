import 'package:flutter/material.dart';

class Insulinrechner extends StatefulWidget {
  const Insulinrechner({Key? key}) : super(key: key);

  @override
  _InsulinrechnerState createState() => _InsulinrechnerState();
}


class _InsulinrechnerState extends State<Insulinrechner> {
  TextEditingController _controller = TextEditingController();
  String _warningMessage = '';
  bool pumpe = true; // Change this value

  void _checkBloodSugar() {
    if (_controller.text.isEmpty) {
      setState(() {
        _warningMessage = 'Bitte geben Sie einen Blutwert ein.';
      });
      return;
    } else {
      double bloodSugarValue = double.tryParse(_controller.text) ?? 0;
      _calculateInsulinBedarf(bloodSugarValue);
    }
  }

  void _calculateInsulinBedarf(double bloodSugarValue) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insulinrechner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(56.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (pumpe)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Current blood sugar value: ',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 22,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    alignment: Alignment.center,
                    color: Colors.redAccent,
                    child: const Text(
                      '67', // mock for blood sugar value
                      style: TextStyle(
                        fontSize: 90.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Aktuellen Blutwert (mg/dl) eingeben',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

