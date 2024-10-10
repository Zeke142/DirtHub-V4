import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'location_picker_page.dart'; // Assuming you have the location picker in the same directory

class SellerForm extends StatefulWidget {
  const SellerForm({Key? key}) : super(key: key);

  @override
  _SellerFormState createState() => _SellerFormState();
}

class _SellerFormState extends State<SellerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dirtTypeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Position? _selectedLocation; // Store selected location

  // Method to handle location selection
  void _pickLocation() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(
          onLocationSelected: (Position position) {
            setState(() {
              _selectedLocation = position;
            });
          },
        ),
      ),
    );
  }

  // Method to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validate that a location has been selected
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location')),
        );
        return;
      }

      // Add document to Firestore
      await FirebaseFirestore.instance.collection('sellers').add({
        'dirt_type': _dirtTypeController.text.trim(),
        'quantity': int.tryParse(_quantityController.text.trim()), // Ensure this is an integer
        'price': double.tryParse(_priceController.text.trim()), // Ensure this is a double
        'location': GeoPoint(
          _selectedLocation!.latitude,
          _selectedLocation!.longitude,
        ), // Save as GeoPoint
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the fields after submission
      _dirtTypeController.clear();
      _quantityController.clear();
      _priceController.clear();
      _selectedLocation = null;

      // Optional: Navigate back or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seller information submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Dirt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity (cu. yds.)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (\$)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _pickLocation,
                      child: Text(
                        _selectedLocation == null
                            ? 'Pick Location'
                            : 'Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}