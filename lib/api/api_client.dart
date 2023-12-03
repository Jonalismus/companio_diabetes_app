import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendDataToServer() async {
  final response = await http.post(
    'https://your-server-url/calculate',
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'api_key': 'your_secret_api_key',
      'value': 42,  // Replace with the data you want to send for calculations
    }),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body)['result'];
    print('Server response: $result');
  } else {
    print('Error: ${response.statusCode}');
  }
}
