import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'location_picker_page.dart'; // Import your location picker page

class SellersPage extends StatefulWidget {
  const SellersPage({super.key});

  @override
  _SellersPageState createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form inputs
  final TextEditingController _dirtTypeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _location = "Select Location";
  GeoPoint? _selectedLocation; // Geopoint object for storing location

  // Method to open location picker
  void _openLocationPicker() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(
          onLocationSelected: (Position position) {
            setState(() {
              _location = "Location: ${position.latitude}, ${position.longitude}";
              _selectedLocation = GeoPoint(position.latitude, position.longitude);
            });
          },
        ),
      ),
    );
  }

  // Method to submit data to Firestore
  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('sellers').add({
          'dirtType': _dirtTypeController.text,
          'quantity': int.parse(_quantityController.text),
          'price': double.parse(_priceController.text),
          'location': _selectedLocation, // Add the location as GeoPoint
        });
        print('Data submitted successfully');
      } catch (e) {
        print('Error submitting data: $e');
      }
    } else {
      print('Form is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sellers Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dirt type input
              TextFormField(
                controller: _dirtTypeController,
                decoration: const InputDecoration(labelText: 'Dirt Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dirt type';
                  }
                  return null;
                },
              ),
              // Quantity input
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity (cu. yds.)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Quantity must be a number';
                  }
                  return null;
                },
              ),
              // Price input
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (\$)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Price must be a valid number';
                  }
                  return null;
                },
              ),
              // Location picker
              TextButton(
                onPressed: _openLocationPicker,
                child: const Text('Pick Location'),
              ),
              Text(_location),
              const SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}