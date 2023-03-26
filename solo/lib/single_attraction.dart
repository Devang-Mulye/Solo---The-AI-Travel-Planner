import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'travel_plan.dart';

class DaySelectionScreen extends StatefulWidget {
  final List<String> selectedLabels;

  const DaySelectionScreen({required this.selectedLabels});

  @override
  _DaySelectionScreenState createState() => _DaySelectionScreenState();
}

class _DaySelectionScreenState extends State<DaySelectionScreen> {
  List<String> _selectedLabels = [];

  @override
  void initState() {
    super.initState();
    _selectedLabels = widget.selectedLabels;
  }

  Future<void> _sendSelectedLabelToAPI(String label) async {
    final url = Uri.parse('http://127.0.0.1:5000/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'label': label}),
    );

    if (response.statusCode == 200) {
      print('Successfully sent label to API');
    } else {
      print('Failed to send label to API');
    }
  }

  void _navigateToTravelPlanPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TravelPlanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Labels'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final String item = _selectedLabels.removeAt(oldIndex);
                  _selectedLabels.insert(newIndex, item);
                });
              },
              children: List.generate(
                _selectedLabels.length,
                (index) {
                  return Card(
                    key: ValueKey(_selectedLabels[index]),
                    child: ListTile(
                      title: Text(
                        _selectedLabels[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _selectedLabels.isNotEmpty
                ? () async {
                    final labelToSend = _selectedLabels.removeAt(0);
                    await _sendSelectedLabelToAPI(labelToSend);
                    setState(() {});
                    if (_selectedLabels.isEmpty) {
                      _navigateToTravelPlanPage();
                    }
                  }
                : null,
            child: const Text('Send Label to API'),
          ),
        ],
      ),
    );
  }
}
