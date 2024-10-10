import 'package:flutter/material.dart';

class SellerForm extends StatefulWidget {
  const SellerForm({super.key});

  @override
  _SellerFormState createState() => _SellerFormState();
}

class _SellerFormState extends State<SellerForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Dirt type dropdown items
  final List<String> _dirtTypes = ['Topsoil', 'Fill Dirt', 'Clay', 'Sand', 'Gravel'];
  String? _selectedDirtType;

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
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
            children: [
              // Dropdown for Dirt Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Dirt Type'),
                value: _selectedDirtType,
                items: _dirtTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDirtType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the dirt type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16.0),

              // Text input for Quantity with "cu. yds." suffix
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  suffixText: 'cu. yds.', // Fixed text at the end
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16.0),

              // Text input for Price with "$" prefix
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$', // Fixed $ sign before the input
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16.0),

              // Text input for Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission (e.g., save to database)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}