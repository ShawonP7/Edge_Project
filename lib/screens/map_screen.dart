import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;

  final List<Map<String, dynamic>> mosques = [
    {
      "name": "Masjid Al Noor",
      "latitude": 40.7128,
      "longitude": -74.0060,
    },
    {
      "name": "Masjid Al Rahman",
      "latitude": 40.730610,
      "longitude": -73.935242,
    },
    {
      "name": "Masjid Umar",
      "latitude": 40.758896,
      "longitude": -73.985130,
    }
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mosques Map")),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _buildMosqueMarkers(),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMosqueMarkers() {
    return mosques.map((mosque) {
      return Marker(
        point: LatLng(mosque['latitude'], mosque['longitude']),
        width: 80.0,
        height: 80.0,
        child: Icon(Icons.location_on, color: Colors.red, size: 40),
      );
    }).toList();
  }
}
