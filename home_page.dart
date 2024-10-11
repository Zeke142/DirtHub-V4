import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? selectedPosition; // Store the selected position

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          // Button to pick a location
          ElevatedButton(
            onPressed: () async {
              // Navigate to the Location Picker Page and wait for the result
              final position = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationPickerPage(
                    onLocationSelected: (LatLng position) {
                      // Handle the selected position here
                      setState(() {
                        selectedPosition = position; // Save the selected position
                      });
                    },
                  ),
                ),
              );
            },
            child: const Text('Pick Location'),
          ),
          // Buttons to navigate to other pages
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/buyers'); // Navigate to Buyers Page
            },
            child: const Text('Go to Buyers Page'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/sellers'); // Navigate to Sellers Page
            },
            child: const Text('Go to Sellers Page'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/transport'); // Navigate to Transport Page
            },
            child: const Text('Go to Transport Page'),
          ),
          // Display Google Map or message if no location is selected
          if (selectedPosition != null)
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: selectedPosition!,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('selectedLocation'),
                    position: selectedPosition!,
                  ),
                },
              ),
            )
          else
            const Expanded(
              child: Center(child: Text('No location selected')),
            ),
        ],
      ),
    );
  }
}