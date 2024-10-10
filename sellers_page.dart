import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_picker_page.dart'; // Import the location picker page

class SellersPage extends StatefulWidget {
  const SellersPage({super.key}); // Kept 'key' as super parameter

  @override
  _SellersPageState createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  String _location = "Select Location";
  String _selectedDirtType = 'Topsoil'; // Default dirt type
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _openLocationPicker() async {
    // Navigate to the location picker page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(
          onLocationSelected: (Position position) {
            setState(() {
              _location = "Location: ${position.latitude}, ${position.longitude}";
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('This is the Sellers Page'), // Existing text from original SellersPage
            ),
            const SizedBox(height: 20),

            // Location Picker
            TextButton(
              onPressed: _openLocationPicker,
              child: const Text('Pick Location'),
            ),
            Text(_location),
            const SizedBox(height: 20),

            // Dirt Type Dropdown
            const Text('Dirt Type:'),
            DropdownButton<String>(
              value: _selectedDirtType,
              items: <String>['Topsoil', 'Clay', 'Sand', 'Gravel', 'Silt'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDirtType = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Quantity Input
            const Text('Quantity (cu. yds.):'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter quantity',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('cu. yds.'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Price Input
            const Text('Price:'),
            Row(
              children: [
                const Text('\$'),
                const SizedBox(width: 5),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter price',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Submit Button (For adding seller data later)
            ElevatedButton(
              onPressed: () {
                // Add functionality here for submitting data
                print('Dirt Type: $_selectedDirtType');
                print('Quantity: ${_quantityController.text}');
                print('Price: ${_priceController.text}');
                print('Location: $_location');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}