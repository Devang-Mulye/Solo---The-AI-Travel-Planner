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
  int _numberOfDays = 1;
  Map<int, List<String>> _plans = {};

  Future<String> _getPlanForLabel(String label) async {
    final url = Uri.parse('http://127.0.0.1:5000/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'label': label}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['result'];
    } else {
      return 'Failed to get plan from API';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Plan'),
      ),
      body: Column(
        children: [
          DropdownButton(
            value: _numberOfDays,
            onChanged: (int? newValue) {
              setState(() {
                _numberOfDays = newValue ?? 1;
              });
            },
            items: List.generate(
              7,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1} days'),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.wait(
                widget.selectedLabels
                    .map((label) => _getPlanForLabel(label))
                    .toList(),
              ),
              builder: (context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching plans'));
                }

                final plans = snapshot.data ?? [];

                // Split plans into separate days
                _plans = {};
                for (var i = 0; i < plans.length; i++) {
                  final dayNumber = i % _numberOfDays;
                  _plans[dayNumber] = _plans[dayNumber] ?? [];
                  _plans[dayNumber]!.add(plans[i]);
                }

                return ListView.builder(
                  itemCount: _plans.length,
                  itemBuilder: (context, index) {
                    final dayNumber = index + 1;
                    final plansForDay = _plans[dayNumber] ?? [];

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
          ),
        ],
      ),
    );
  }
}
