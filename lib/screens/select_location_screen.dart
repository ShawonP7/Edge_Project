import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({Key? key}) : super(key: key);

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  bool _isLoading = true;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ✅ Automatically Get User's Current Location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium, // Faster location detection
      distanceFilter: 50, // Update location every 50 meters
    );

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
        timeLimit: Duration(seconds: 5), // Timeout to avoid long loading
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation; // Start with current location
        _isLoading = false;
        _mapController.move(_currentLocation!, 15.0);
      });
    } catch (e) {
      print("⚠️ Location fetching error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ Select Location by Tapping on Map
  void _selectLocation(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  // ✅ Confirm Selection and Return Location
  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Mosque Location")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // ⏳ Loading animation
          : FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentLocation ?? LatLng(23.8103, 90.4125), // Default: Dhaka
          initialZoom: 15.0,
          onTap: (tapPosition, point) {
            _selectLocation(point);
          },
        ),
        children: [
          // ✅ Free OpenStreetMap Tiles
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.de/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          // ✅ Show Current Location Marker
          if (_currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentLocation!,
                  width: 40.0,
                  height: 40.0,
                  child: Icon(Icons.my_location, color: Colors.blue, size: 40),
                ),
              ],
            ),
          // ✅ Show Selected Mosque Location Marker
          if (_selectedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedLocation!,
                  width: 40.0,
                  height: 40.0,
                  child: Icon(Icons.location_on, color: Colors.red, size: 40),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "confirmLocation",
        child: Icon(Icons.check),
        onPressed: _confirmLocation,
      ),
    );
  }
}
