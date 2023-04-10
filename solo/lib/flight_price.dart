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
  final String _apiUrl = 'https://solo-travel-planner.onrender.com/predict_flight_price';
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'airline',
                      decoration: InputDecoration(
                        labelText: 'Airline',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'Source',
                      decoration: InputDecoration(
                        labelText: 'Source',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'Destination',
                      decoration: InputDecoration(
                        labelText: 'Destination',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'Dep_Time',
                      decoration: InputDecoration(
                        labelText: 'Departure Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'Arrival_Time',
                      decoration: InputDecoration(
                        labelText: 'Arrival Time',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'stops',
                      decoration: InputDecoration(
                        labelText: 'Number of Stops',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                      ]),
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Predict'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0),
              Text(
                _result,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
