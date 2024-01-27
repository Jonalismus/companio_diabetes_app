import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import '../../utilis/colors_utilis.dart';
import 'Services/notifi_service.dart';


class StepCounterPage extends StatefulWidget {
  const StepCounterPage({Key? key}) : super(key: key);

  @override
  _StepCounterPageState createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  late StreamController<int> _resetStepsController;
  late StreamSubscription<int> _resetStepsSubscription;

  String _status = '?', _steps = '?';

  final NotificationService _notificationService = NotificationService();

  int _lastStepCount = 0;
  DateTime _lastStepTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _notificationService.initNotification();
    _setupResetTimer();
  }

  void _setupResetTimer() {
    Timer.periodic(Duration(days: 1), (Timer timer) {
      _resetSteps();
    });

    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);
    Duration timeUntilMidnight = midnight.difference(now);

    if (timeUntilMidnight.inMilliseconds > 0) {
      Timer(Duration(milliseconds: timeUntilMidnight.inMilliseconds), _resetSteps);
    }
  }

  void _resetSteps() {
    setState(() {
      _steps = '0';
    });
    _lastStepCount = 0;
    _lastStepTime = DateTime.now();
  }

  @override
  void dispose() {
    _resetStepsController.close();
    _resetStepsSubscription.cancel();
    super.dispose();
  }


  Future<void> showNotification() async {
    print('show notification');
    await _notificationService.showNotification(
      title: 'Vorsicht!',
      body: 'Sie haben sich viel bewegt. Behalten Sie Ihren Blutzuckerwert im Auge.',
    );
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      int currentSteps = event.steps;
      _steps = currentSteps.toString();

      if (currentSteps - _lastStepCount >= 5000 &&
          DateTime.now().difference(_lastStepTime).inMinutes <= 30) {
        showNotification();
      }

      _lastStepCount = currentSteps;
      _lastStepTime = DateTime.now();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schrittzähler'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Gemachte Schritte',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              _steps,
              style: TextStyle(fontSize: 60),
            ),
            Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            Text(
              'Status',
              style: TextStyle(fontSize: 30),
            ),
            Icon(
              _status == 'walking'
                  ? Icons.directions_walk
                  : _status == 'stopped'
                  ? Icons.accessibility_new
                  : Icons.error,
              size: 100,
            ),
            Center(
              child: Text(
                _status,
                style: _status == 'walking' || _status == 'stopped'
                    ? TextStyle(fontSize: 30)
                    : TextStyle(fontSize: 20, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
