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
    'Resources/Attractions/Chhatrapati-Shivaji-Terminus.jpg',
    'Resources/Attractions/Elephanta-caves.jpg',
    'Resources/Attractions/Gateway_of_India.jpg',
    'Resources/Attractions/Marine-Drive.jpg',

    'Resources/Attractions/Afghan-Church.jpeg',
    'Resources/Attractions/Bandra-Fort.jpeg',
    'Resources/Attractions/Essel-World.jpeg',
    // 'Resources/Wankhede-Stadium.jpeg',
    'Resources/Attractions/Girgaon-Chowpathi.jpeg',
    'Resources/Attractions/Global-Vipassana.jpeg',
    'Resources/Attractions/Haji-Ali-Dargah.jpeg',
    'Resources/Attractions/ISKCON-Temple.jpeg',
    'Resources/Attractions/Kidzania.jpeg',
    'Resources/Attractions/Mahim-Church.jpeg',
    'Resources/Attractions/Manori-Beach.jpeg',
    'Resources/Attractions/Mumbadevi-temple.jpeg',
    'Resources/Attractions/Mumbai-Beaches.jpeg',
    'Resources/Attractions/Nehru-Planetarium.jpeg',
    'Resources/Attractions/Priyadarshini-Park.png',
    'Resources/Attractions/Shree-Siddhivinayak-Temple.jpeg',
    // 'Resources/Sion-Fort.jpeg',
    'Resources/Attractions/Vasai-Fort.jpeg',
    'Resources/Attractions/VJTI-Udyaan.jpeg',
    'Resources/Attractions/Hanging-Gardens.jpeg',
  ];

  final List<String> imageLabels = [
    'Chhatrapati Shivaji Maharaj Terminus',
    'Elephanta Caves',
    'Gateway Of India Mumbai',
    'Marine Drive',
    'Afghan Church Official',
    'Bandra Fort',
    'EsselWorld',
    // 'Wankhede-Stadium',
    'Girgaon Chowpatty',
    'Global Vipassana Pagoda',
    'Haji Ali Dargah',
    'ISKCON Chowpatty (Sri Sri Radha Gopinath Mandir)',
    'KidZania Mumbai',
    'St. Michaels Church Mahim',
    'Manori Beach',
    'Mumbadevi temple',
    'Mumbai-Beaches',
    'Nehru planetarium',
    'Priyadarshini Park',
    'Shree Siddhivinayak Temple'
        // 'Sion-Fort',
        'Vasai Fort',
    'Veermata Jijabai Bhosale Udyan And Zoo',
    'Horniman Circle Garden',
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
      body:GridView.builder(
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                imageLabels[index],
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  },
)

      // GridView.builder(
      //   itemCount: imageList.length,
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     mainAxisSpacing: 16,
      //     crossAxisSpacing: 16,
      //   ),
      //   itemBuilder: (BuildContext context, int index) {
      //     final isSelected = _selectedImages.contains(index);
      //     return InkWell(
      //       onTap: () {
      //         _selectImage(index);
      //       },
      //       child: Stack(
      //         children: [
      //           AnimatedOpacity(
      //             duration: const Duration(milliseconds: 300),
      //             opacity: isSelected ? 0.5 : 1.0,
      //             child: Image.asset(
      //               imageList[index],
      //               height: 150,
      //               width: 150,
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           if (isSelected)
      //             const Positioned.fill(
      //               child: Icon(Icons.check, color: Colors.blue),
      //             ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      
    );
  }
}
