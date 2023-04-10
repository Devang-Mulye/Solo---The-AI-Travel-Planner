import 'package:flutter/material.dart';
import 'display_attractions.dart';

class TravelScreen extends StatefulWidget {
  @override
  _TravelScreenState createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  String dest = '';
  int days = 1;

  final List<int> _daysList = List<int>.generate(31, (index) => index + 1);

  void _navigateToAttractionsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttractionsScreen(maxSelectedImages: days,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel App'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Resources/back_input.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Destination',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'Montserrat'),
                    onChanged: (value) {
                      setState(() {
                        dest = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Days',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: _daysList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                days = _daysList[index];
                              });
                            },
                            child: Container(
                              width: 60,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: days == _daysList[index]
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  '${_daysList[index]}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToAttractionsScreen(context);
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}