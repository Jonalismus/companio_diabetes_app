import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilis/colors_utilis.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _sendFeedback() async {
    String feedbackText = _feedbackController.text;

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'companiosup@gmail.com',
      query: 'subject=App Feedback&body=' + Uri.encodeComponent('Feedback: $feedbackText'),
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('E-Mail konnte nicht gesendet werden.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _feedbackController,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Geben Sie hier Ihr Feedback ein',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _sendFeedback,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  minimumSize: Size(double.infinity, 60.0),
                ),
                child: const Text('Feedback senden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
