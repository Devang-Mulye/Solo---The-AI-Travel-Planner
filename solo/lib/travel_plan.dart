import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TravelPlanPage extends StatefulWidget {
  final List<String> selectedLabels;

  const TravelPlanPage({required this.selectedLabels});

  @override
  _TravelPlanPageState createState() => _TravelPlanPageState();
}

class _TravelPlanPageState extends State<TravelPlanPage> {
  int _numberOfDays = 4;
  List<String> _plans = [];

  Future<List<String>> _getPlanForLabel(String label) async {
    final url = Uri.parse('http://127.0.0.1:5000/travel-plan');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'label': label}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return List<String>.from(responseData['result']);
    } else {
      return ['Failed to get plan from API'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Plan'),
      ),
      body: FutureBuilder(
        future: Future.wait(
          widget.selectedLabels
              .map((label) => _getPlanForLabel(label))
              .toList(),
        ),
        builder: (context, AsyncSnapshot<List<List<String>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching plans'));
          }

          // Concatenate all the plans into a single list
          _plans = snapshot.data!.expand((plans) => plans).toList();

          // Split plans into separate days
          // Split plans into separate days
final plansPerDay = (_plans.length / _numberOfDays).ceil(); 
final splitPlans = List.generate(_numberOfDays - 1, (dayIndex) {
  final startIndex = dayIndex * plansPerDay;
  final endIndex = startIndex + plansPerDay;
  return _plans.sublist(startIndex, endIndex);
});
// Add the remaining plans to the last day
final remainingPlans = _plans.sublist(plansPerDay * (_numberOfDays - 1));
splitPlans.add(remainingPlans); 


          return ListView.separated(
            itemCount: _numberOfDays,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final dayNumber = index + 1;
              final plansForDay = splitPlans[index];

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Day $dayNumber',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plansForDay.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(plansForDay[index]),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
