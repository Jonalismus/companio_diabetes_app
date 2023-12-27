import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Geben Sie hier Ihr Feedback ein',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: _sendFeedback,
              child: const Text('Feedback senden'),
            ),
          ],
        ),
      ),
    );
  }
}
