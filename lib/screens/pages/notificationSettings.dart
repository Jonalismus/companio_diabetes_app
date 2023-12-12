import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

import 'Services/notifi_service.dart';

DateTime scheduleTime = DateTime.now();

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NotificationSettings> createState() => _NotificationSettings();
}

class _NotificationSettings extends State<NotificationSettings> {
  bool isTimeSelected = false;
  bool isNotificationScheduled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            AppBar(
              title: Text("Medikamenten-Erinnerung"),
            ),
            // Logo hinzufügen
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/rememberLogo.png', height: 300, width: 300), // Passe die Größe an
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isNotificationScheduled)
                    DatePickerTxt(
                      onDateTimeSelected: () {
                        setState(() {
                          isTimeSelected = true;
                        });
                      },
                    ),
                  if (isTimeSelected && !isNotificationScheduled)
                    ScheduleBtn(onScheduled: () {
                      setState(() {
                        isNotificationScheduled = true;
                      });
                    }),
                  if (isNotificationScheduled)
                    Text('Ihre Erinnerung wurde festgelegt',
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  final VoidCallback onDateTimeSelected;

  const DatePickerTxt({
    Key? key,
    required this.onDateTimeSelected,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        picker.DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) {
            scheduleTime = date;
            widget.onDateTimeSelected();
          },
          onConfirm: (date) {},
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time,
            color: Colors.white,
            size: 24.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            'Wähle ein Datum und eine Uhrzeit',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  final VoidCallback onScheduled;

  const ScheduleBtn({
    Key? key,
    required this.onScheduled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Erinnerung bestätigen'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        NotificationService().scheduleNotification(
          title: 'Medikamenten einnahme',
          body: 'Es ist Zeit, ihre Medikamente einzunehmen!',
          scheduledNotificationDateTime: scheduleTime,
        );
        onScheduled();
      },
    );
  }
}

Color hexStringToColor(String hexString) {
  return Color(int.parse(hexString.replaceAll("#", ""), radix: 16) + 0xFF000000);
}
