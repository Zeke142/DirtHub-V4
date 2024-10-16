import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  final Function(LatLng) onLocationSelected; // Changed from Position to LatLng

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

  // Submit selected location back to the HomePage
  void _submitSelectedLocation() {
    if (_selectedLatLng != null) {
      // Call the onLocationSelected callback with the selected LatLng
      widget.onLocationSelected(_selectedLatLng!);
      Navigator.pop(context); // Navigate back to HomePage
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