import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model_selection.dart';

class HotelVacancy extends StatefulWidget {
  const HotelVacancy({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HotelVacancy> {
  double prediction = 0;

  Future<void> _getPrediction() async {
    final response = await http.get(Uri.parse('https://solo-travel-planner.onrender.com/predict_hotel_vacancy'));
    if (response.statusCode == 200) {
      setState(() {
        prediction = double.parse(response.body);
      });
    } else {
      throw Exception('Failed to get prediction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getPrediction,
              child: Text('Get Prediction'),
            ),
            SizedBox(height: 20),
            Text(
              'Prediction: $prediction',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
