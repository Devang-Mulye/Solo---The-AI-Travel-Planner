import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Day Selection',
    home: DaySelectionScreen(),
  ));
}

class DaySelectionScreen extends StatefulWidget {
  @override
  _DaySelectionScreenState createState() => _DaySelectionScreenState();
}

class _DaySelectionScreenState extends State<DaySelectionScreen> {
  int _selectedDay = 1;

  void _selectDay(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Selection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DAY $_selectedDay',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDay(1),
                  child: const Text('Day 1'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectDay(2),
                  child: const Text('Day 2'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectDay(3),
                  child: const Text('Day 3'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NextPage()),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
      ),
      body: const Center(
        child: Text('This is the next page.'),
      ),
    );
  }
}
