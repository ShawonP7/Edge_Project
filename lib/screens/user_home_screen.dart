import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'mosque_details.dart';  // Import the MosqueDetailsScreen
import 'dart:math';
import 'package:geocoding/geocoding.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool _isLoading = true;
  LatLng? _currentLocation;
  String _locationName = "Unknown Location";
  List<Map<String, dynamic>> _nearbyMosques = [];

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  // ✅ Fetch User's Current Location
  Future<void> _fetchUserLocation() async {
    try {
      // Request permission and get location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _convertLocationToName(position.latitude, position.longitude);
      _fetchNearbyMosques();
    } catch (e) {
      setState(() {
        _locationName = "Unable to fetch location";
        _isLoading = false;
      });
    }
  }

  // ✅ Convert Coordinates to Readable Location Name
  Future<void> _convertLocationToName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _locationName = "${place.locality ?? "Unknown"}, ${place.country ?? "Unknown"}";
        });
      }
    } catch (e) {
      setState(() {
        _locationName = "Unknown Location";
      });
    }
  }

  // ✅ Fetch Nearby Mosques from Firestore
  Future<void> _fetchNearbyMosques() async {
    try {
      QuerySnapshot mosqueSnapshot = await FirebaseFirestore.instance.collection("mosques").get();
      List<Map<String, dynamic>> mosqueList = [];

      for (var doc in mosqueSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Fetching description and location correctly
        String description = data["description"] ?? "No description available"; // Default value if not found
        Map<String, dynamic> location = data["location"] ?? {};
        double latitude = location["latitude"] ?? 0.0;  // Default to 0 if latitude is not found
        double longitude = location["longitude"] ?? 0.0; // Default to 0 if longitude is not found

        double distance = _calculateDistance(
          _currentLocation?.latitude ?? 0.0,
          _currentLocation?.longitude ?? 0.0,
          latitude,
          longitude,
        );

        mosqueList.add({
          "mosque_name": data["mosque_name"] ?? "Unnamed Mosque",
          "description": description,  // Add description to the mosque data
          "location": location,  // Add location to the mosque data
          "distance": distance,
          "prayer_times": data["prayer_times"] ?? {},  // Grab prayer times from Firestore
          "id": doc.id,
        });
      }

      mosqueList.sort((a, b) => a["distance"].compareTo(b["distance"]));

      setState(() {
        _nearbyMosques = mosqueList;
        _isLoading = false; // Stop loading after fetching data
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ Calculate Distance Between Two Coordinates (Haversine Formula)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double radius = 6371; // Earth's radius in km
    double dLat = (lat2 - lat1) * (pi / 180);
    double dLon = (lon2 - lon1) * (pi / 180);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * (pi / 180)) *
            cos(lat2 * (pi / 180)) *
            (sin(dLon / 2) * sin(dLon / 2));

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          "Nearby Mosques",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.white),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.tealAccent))  // Loading Indicator
          : Column(
        children: [
          // ✅ User's Current Location
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.blueGrey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/logo.png"), // Replace with your logo
                  radius: 25,
                ),
                SizedBox(width: 15),
                Text(
                  _locationName,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: _nearbyMosques.length,
              itemBuilder: (context, index) {
                var mosque = _nearbyMosques[index];

                return GestureDetector(
                  onTap: () {
                    // ✅ Navigate to Mosque Details Screen when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MosqueDetailsScreen(
                          mosqueName: mosque["mosque_name"] ?? "Unnamed Mosque",
                          description: mosque["description"] ?? "No description available",
                          mosqueLocation: mosque["location"] != null
                              ? LatLng(
                            mosque["location"]["latitude"] ?? 0.0,
                            mosque["location"]["longitude"] ?? 0.0,
                          )
                              : LatLng(0.0, 0.0),
                          prayerTimes: mosque["prayer_times"] ?? {},
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mosque["mosque_name"] ?? "Unnamed Mosque",
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Distance: ${mosque["distance"]?.toStringAsFixed(2) ?? "N/A"} km",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
