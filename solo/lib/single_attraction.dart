import 'package:flutter/material.dart';
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

  void _navigateToTravelPlanPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TravelPlanPage(selectedLabels: _selectedLabels),
      ),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToTravelPlanPage();
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
