import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TravelPlanPage extends StatefulWidget {
  @override
  _TravelPlanPageState createState() => _TravelPlanPageState();
}

class _TravelPlanPageState extends State<TravelPlanPage> {
  final TextEditingController _locationController = TextEditingController();
  String _selectedDay = 'Day 1';
  String _travelPlan = '';

  Future<void> _generateTravelPlan() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/travel-plan'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'label': _locationController.text,
        'day': int.parse(_selectedDay.split(' ')[1])
      }),
    );

    final data = jsonDecode(response.body);
    setState(() {
      _travelPlan = data['result'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _selectedDay,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDay = newValue!;
                });
              },
              items: <String>['Day 1', 'Day 2', 'Day 3', 'Day 4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Generate Travel Plan'),
              onPressed: _generateTravelPlan,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_travelPlan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
