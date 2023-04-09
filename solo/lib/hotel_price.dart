import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelPricePredictor extends StatefulWidget {
  @override
  _HotelPricePredictorState createState() => _HotelPricePredictorState();
}

class _HotelPricePredictorState extends State<HotelPricePredictor> {
  final TextEditingController _hotelNameController = TextEditingController();
  String _predictedPrice = '';

void _predictPrice() async {
  String url = 'http://127.0.0.1:5000/predict_hotel_price';
  Map<String, String> queryParams = {'hotel_name': _hotelNameController.text};
  var uri = Uri.parse(url).replace(queryParameters: queryParams);
  var response = await http.get(uri);
  var jsonResponse = jsonDecode(response.body);

  setState(() {
    _predictedPrice = jsonResponse['predicted_price'].toStringAsFixed(2);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Price Predictor'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Enter the name of the hotel:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Container(
            width: 300,
            child: TextField(
              controller: _hotelNameController,
              decoration: InputDecoration(
                hintText: 'Hotel name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _predictPrice,
            child: Text('Predict price'),
          ),
          SizedBox(height: 20),
          Text(
            'Predicted price:',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            _predictedPrice,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
