//API Skelleton
/*
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

Future<void> uploadCSV(File file) async {
  var uri = Uri.parse("http:10.0.8.15");

  var request = http.MultipartRequest("POST", uri);

  var fileStream = http.ByteStream(file.openRead());
  var length = await file.length();
  var multipartFile = http.MultipartFile('file', fileStream, length,
      filename: basename(file.path),
      contentType: MediaType('application', 'csv'));

  request.files.add(multipartFile);

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      
      print(await response.stream.bytesToString());
    } else {
      
      print('Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


void main() async {
  File csvFile = File("/path/to/your/file.csv");
  await uploadCSV(csvFile);
}
*/