import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

class FlightPricePredictor extends StatefulWidget {
  @override
  _FlightPricePredictorState createState() => _FlightPricePredictorState();
}

class _FlightPricePredictorState extends State<FlightPricePredictor> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final String _apiUrl = 'http://localhost:5000/predict_flight_price';
  String _result = '';

  void _submitForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> formData = _formKey.currentState!.value;
      var response = await http.post(
        Uri.parse(_apiUrl),
        body: jsonEncode(formData),
        headers: {'Content-Type': 'application/json'},
      );
      setState(() {
        _result = response.body;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Price Predictor'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'airline',
                    decoration: InputDecoration(labelText: 'Airline'),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: 'Source',
                    decoration: InputDecoration(labelText: 'Source'),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: 'Destination',
                    decoration: InputDecoration(labelText: 'Destination'),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: 'Dep_Time',
                    decoration: InputDecoration(labelText: 'Departure Time'),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: 'Arrival_Time',
                    decoration: InputDecoration(labelText: 'Arrival Time'),
                    validator: FormBuilderValidators.required(),
                  ),
                  FormBuilderTextField(
                    name: 'stops',
                    decoration: InputDecoration(labelText: 'Number of Stops'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Predict'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
