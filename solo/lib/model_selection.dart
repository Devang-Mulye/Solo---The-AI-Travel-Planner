import 'package:flutter/material.dart';
import 'flight_prediction.dart';
import 'hotel_prize.dart';
import 'hotel_vacancy.dart';

class ModelSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Front End'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DummyPage('Flight Prediction'),
                  ),
                );
              },
              child: Text('Flight Prediction'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelVacancy(),
                  ),
                );
              },
              child: Text('Hotel Vacancy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelPricePredictor(),
                  ),
                );
              },
              child: Text('Hotel Price'),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyPage extends StatelessWidget {
  final String title;

  DummyPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is a dummy page'),
      ),
    );
  }
}
