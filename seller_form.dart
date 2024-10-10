import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final TextEditingController _locationController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Add document to Firestore
      await FirebaseFirestore.instance.collection('sellers').add({
        'dirt_type': _dirtTypeController.text.trim(),
        'quantity': int.tryParse(_quantityController.text.trim()), // Ensure this is an integer
        'price': double.tryParse(_priceController.text.trim()), // Ensure this is a double
        'location': _locationController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the fields after submission
      _dirtTypeController.clear();
      _quantityController.clear();
      _priceController.clear();
      _locationController.clear();
      
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
                decoration: const InputDecoration(labelText: 'Price ($)'),
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
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
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
