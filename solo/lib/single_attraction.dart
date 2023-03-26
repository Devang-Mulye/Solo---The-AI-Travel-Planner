import 'package:flutter/material.dart';

class DaySelectionScreen extends StatelessWidget {
  final List<String> selectedLabels;

  const DaySelectionScreen({required this.selectedLabels});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Labels'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Labels:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              selectedLabels.join(', '),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
