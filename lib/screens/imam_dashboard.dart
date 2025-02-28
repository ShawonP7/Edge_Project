import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class ImamDashboardScreen extends StatefulWidget {
  @override
  _ImamDashboardScreenState createState() => _ImamDashboardScreenState();
}

class _ImamDashboardScreenState extends State<ImamDashboardScreen> {
  final _descriptionController = TextEditingController();
  Map<String, TextEditingController> _prayerTimeControllers = {};
  LatLng _mosqueLocation = LatLng(23.8103, 90.4125);
  String _locationName = "Fetching location...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMosqueData();
  }

  // ✅ Fetch Mosque Data from Firestore
  Future<void> _fetchMosqueData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot mosqueDoc =
    await FirebaseFirestore.instance.collection("mosques").doc(user.uid).get();

    if (mosqueDoc.exists) {
      var data = mosqueDoc.data() as Map<String, dynamic>;

      double lat = double.tryParse(data["location"]["latitude"].toString()) ?? 23.8103;
      double lng = double.tryParse(data["location"]["longitude"].toString()) ?? 90.4125;

      setState(() {
        _mosqueLocation = LatLng(lat, lng);
        _descriptionController.text = data["description"] ?? "";
        _isLoading = false;
      });

      _convertLocationToName(lat, lng);
      _initializePrayerTimeControllers(data["prayer_times"] ?? {});
    }
  }

  // ✅ Convert Coordinates to Location Name
  Future<void> _convertLocationToName(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _locationName = "${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      setState(() {
        _locationName = "Unknown Location";
      });
    }
  }

  // ✅ Initialize Prayer Time Controllers
  void _initializePrayerTimeControllers(Map<String, dynamic> prayerTimes) {
    List<String> prayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
    for (var prayer in prayers) {
      _prayerTimeControllers[prayer] = TextEditingController(
        text: prayerTimes[prayer] ?? "00:00 AM",
      );
    }
  }

  // ✅ Save Mosque Description & Prayer Times
  Future<void> _saveUpdates() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    Map<String, String> updatedPrayerTimes = {};
    _prayerTimeControllers.forEach((key, controller) {
      updatedPrayerTimes[key] = controller.text.trim();
    });

    await FirebaseFirestore.instance.collection("mosques").doc(user.uid).update({
      "description": _descriptionController.text.trim(),
      "prayer_times": updatedPrayerTimes,
    });

    Fluttertoast.showToast(msg: "Updated Successfully!", backgroundColor: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          "Imam Dashboard",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.tealAccent))
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Mosque Location
            Text(
              "Mosque Location",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 250,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: _mosqueLocation,
                    initialZoom: 14.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _mosqueLocation,
                          child: Icon(Icons.location_on, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
            Text(
              _locationName,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.tealAccent),
            ),

            SizedBox(height: 30),

            // ✅ Mosque Description
            Text(
              "Mosque Description",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write about your mosque...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.blueGrey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 30),

            // ✅ Prayer Times
            Text(
              "Prayer Times",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),

            Column(
              children: _prayerTimeControllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: entry.value,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: entry.key,
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.blueGrey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 30),

            // ✅ Save Button
            Center(
              child: ElevatedButton(
                onPressed: _saveUpdates,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text("Save Updates", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
