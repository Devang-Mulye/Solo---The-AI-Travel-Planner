import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> predict(String depTime, String arrivalTime, int stops, String airline, String source, String destination) async {
  final url = Uri.parse('http://localhost:5000/predict');
  final response = await http.post(url, body: {
    'Dep_Time': depTime,
    'Arrival_Time': arrivalTime,
    'stops': stops.toString(),
    'airline': airline,
    'Source': source,
    'Destination': destination,
  });
  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return responseData;
  } else {
    throw Exception('Failed to load data');
  }
}
