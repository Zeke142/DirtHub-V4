import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerPage extends StatefulWidget {
  final Function(Position) onLocationSelected;

  const LocationPickerPage({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _LocationPickerPageState createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {});
      widget.onLocationSelected(_currentPosition!); // Pass location back
      Navigator.pop(context); // Navigate back to the Sellers Page
    } catch (e) {
      print('Error getting location: $e');
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
      appBar: AppBar(title: const Text('Pick Location')),
      body: Center(
        child: _currentPosition == null
            ? CircularProgressIndicator()
            : Text('Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}'),
      ),
    );
  }
}