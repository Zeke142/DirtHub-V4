import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  final Function(Position) onLocationSelected;

  const LocationPickerPage({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  Position? _currentPosition;
  LatLng? _selectedLatLng; // To store selected location on the map
  GoogleMapController? _mapController;

  // Method to get current location
  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {});
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Callback when a location is selected on the map
  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLatLng = latLng;
    });
  }

  // Submit selected location back to the SellersPage
  void _submitSelectedLocation() {
    if (_selectedLatLng != null) {
      // Create a Position object to pass to the callback
      final selectedPosition = Position(
        latitude: _selectedLatLng!.latitude,
        longitude: _selectedLatLng!.longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0, // Add this field
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
      widget.onLocationSelected(selectedPosition);
      Navigator.pop(context); // Navigate back to SellersPage
    } else {
      print('No location selected');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          IconButton(
            onPressed: _submitSelectedLocation,
            icon: const Icon(Icons.check),
            tooltip: 'Confirm Location',
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 16.0,
              ),
              onTap: _onMapTap, // When user taps on the map
              markers: _selectedLatLng != null
                  ? {
                      Marker(
                        markerId: const MarkerId('selected_location'),
                        position: _selectedLatLng!,
                      )
                    }
                  : {},
            ),
    );
  }
}