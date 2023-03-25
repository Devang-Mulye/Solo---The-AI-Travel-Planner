import 'package:flutter/material.dart';
import 'single_attraction.dart';

class AttractionsScreen extends StatefulWidget {
  @override
  _AttractionsScreenState createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  final List<String> imageList = [
    'https://picsum.photos/200/300?random=1',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
    'https://picsum.photos/200/300?random=5',
    'https://picsum.photos/200/300?random=6',
    'https://picsum.photos/200/300?random=7',
    'https://picsum.photos/200/300?random=8',
    'https://picsum.photos/200/300?random=9',
    'https://picsum.photos/200/300?random=10',
    'https://picsum.photos/200/300?random=11',
    'https://picsum.photos/200/300?random=12',
    'https://picsum.photos/200/300?random=13',
    'https://picsum.photos/200/300?random=14',
    'https://picsum.photos/200/300?random=15',
    'https://picsum.photos/200/300?random=16',
  ];
  final Set<int> _selectedImages = {};
  final int _maxSelectedImages = 6;

  void _selectImage(int index) {
    setState(() {
      if (_selectedImages.contains(index)) {
        _selectedImages.remove(index);
      } else if (_selectedImages.length < _maxSelectedImages) {
        _selectedImages.add(index);
      }
    });
  }

  void _navigateToNextPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DaySelectionScreen()),
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
                  child: Image.network(
                    imageList[index],
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isSelected)
                  Positioned.fill(
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
