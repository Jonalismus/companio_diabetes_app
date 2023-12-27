import 'package:flutter/material.dart';
import 'Services/insulinCalculator.dart';

class Insulinrechner extends StatefulWidget {
  const Insulinrechner({Key? key}) : super(key: key);

  @override
  _InsulinrechnerState createState() => _InsulinrechnerState();
}


class _InsulinrechnerState extends State<Insulinrechner> {
  TextEditingController _controllerGlycose = TextEditingController();
  TextEditingController _controllerCarbohydrates = TextEditingController();

  String _warningMessageOne = '';
  String _warningMessageTwo = '';
  double totalUnitsVal = 60;
  double basalPercentageVal = 0.4;
  double bolusPercentageVal = 0.6;
  int mealsPerDayVal = 3;
  double afterMealTargetGlucoseVal = 90;
  bool pumpe = true; // Change this value
  late double bloodSugarValue = 60; //get from database in future
  late double carbohydrates;
  late double insulinUnits = 0;

  void _checkBloodSugar() {
    if (_controllerGlycose.text.isEmpty) {
      setState(() {
        _warningMessageOne = 'Geben Sie einen Blutwert ein.';
      });
      return;
    } else {
      bloodSugarValue = double.tryParse(_controllerGlycose.text) ?? 0;
    }
  }

  void _checkCarbohydrates() {
    if (_controllerCarbohydrates.text.isEmpty) {
      setState(() {
        _warningMessageTwo = 'Geben Sie Ihren Kohlenhydratwert ein.';
      });
      return;
    } else {
      carbohydrates = double.tryParse(_controllerCarbohydrates.text) ?? 0;
    }
  }

  double calculateInsulinBedarf(double bloodSugarValue, carbsIntake) {
      InsulinCalculator insulinCalc = InsulinCalculator(
          totalUnitsVal,
          basalPercentageVal,
          bolusPercentageVal,
          mealsPerDayVal,
          afterMealTargetGlucoseVal);

      double corrFactor = InsulinCalculator.getCorrectionFactor(
          totalUnitsVal, true, false);
      double premealCorrUnits = insulinCalc.getPremealCorrectionUnits(
          bloodSugarValue, "rapid", corrFactor);
      double afterMealInsulin = insulinCalc.getAfterMealInsulin(
          carbsIntake, premealCorrUnits);
      return afterMealInsulin;
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
                    child: Text('$bloodSugarValue', // mock for blood sugar value
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
                    controller: _controllerGlycose,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Aktuellen Blutwert (mg/dl): ',
                    ),
                  ),
                  const SizedBox(height: 13),
                  ElevatedButton(
                    onPressed: _checkBloodSugar,
                    child: const Text('Blutwert eingeben'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _warningMessageOne,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  TextField(
                  controller: _controllerCarbohydrates,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                  labelText: 'Kohlenhydrate in Gramm: ',
                  ),
                  ),
                  const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _checkCarbohydrates();
                        insulinUnits = calculateInsulinBedarf(bloodSugarValue, carbohydrates);
                        setState(() {
                          Column(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Benötigte Insulin Units: ',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 22,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                alignment: Alignment.center,
                                color: Colors.indigo,
                                child: Text('$insulinUnits', // mock for blood sugar value
                                  style: TextStyle(
                                    fontSize: 90.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],);
                        });
                        },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Insulinbedarf berechnen'),
                    ),
                  const SizedBox(height: 13),
                  Text(
                  _warningMessageTwo,
                  style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  ),
                  ),
                    const SizedBox(height: 1),
                  ],
               ),
              if (insulinUnits>0)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Benötigte Insulin Units: ',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 22,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      alignment: Alignment.center,
                      color: Colors.deepPurple,
                      child: Text('$insulinUnits', // mock for blood sugar value
                        style: TextStyle(
                          fontSize: 90.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
             ],
        ),
      ),
    );
  }
}

