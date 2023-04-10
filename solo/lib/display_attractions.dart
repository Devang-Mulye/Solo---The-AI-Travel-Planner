import 'package:flutter/material.dart';
import 'single_attraction.dart';
import 'Locationinfo.dart';

class AttractionsScreen extends StatefulWidget {
  final int maxSelectedImages;

  AttractionsScreen({required this.maxSelectedImages});

  @override
  _AttractionsScreenState createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  final List<String> imageList = [
    'Resources/Chhatrapati-Shivaji-Terminus.jpg',
    'Resources/Elephanta-caves.jpg',
    'Resources/Gateway_of_India.jpg',
    'Resources/Marine-Drive.jpg',
  ];

  final List<String> imageLabels = [
    'Chhatrapati Shivaji Maharaj Terminus',
    'Elephanta Caves',
    'Gateway Of India Mumbai',
    'Marine Drive',
  ];

  final Set<int> _selectedImages = {};
  late final int _maxSelectedImages;
  List<String> selectedLabels = [];

  @override
  void initState() {
    super.initState();
    _maxSelectedImages = widget.maxSelectedImages;
  }

  void _selectImage(int index) {
    setState(() {
      if (_selectedImages.contains(index)) {
        _selectedImages.remove(index);
        selectedLabels.remove(imageLabels[index]);
      } else if (_selectedImages.length < _maxSelectedImages) {
        _selectedImages.add(index);
        selectedLabels.add(imageLabels[index]);
      }
    });
  }

  void _navigateToNextPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => DaySelectionScreen(selectedLabels: selectedLabels)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Grid'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNextPage,
        child: const Icon(Icons.arrow_forward),
      ),
      body: GridView.builder(
        itemCount: imageList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (BuildContext context, int index) {
          final isSelected = _selectedImages.contains(index);
          return InkWell(
            onTap: () {
              _selectImage(index);
            },
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isSelected ? 0.5 : 1.0,
                  child: Image.asset(
                    imageList[index],
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isSelected)
                  const Positioned.fill(
                    child: Icon(Icons.check, color: Colors.blue),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
