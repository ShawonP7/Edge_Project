import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MosqueDetailsScreen extends StatelessWidget {
  final String mosqueName;
  final String description;
  final LatLng mosqueLocation;
  final Map<String, dynamic> prayerTimes;  // Keep it dynamic for flexibility

  // Constructor with named parameters
  MosqueDetailsScreen({
    Key? key,
    required this.mosqueName,
    required this.description,
    required this.mosqueLocation,
    required this.prayerTimes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the correct order for prayer times
    List<String> prayerTimeOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    // Sort the prayer times based on the fixed order and safely cast them to String
    Map<String, String> sortedPrayerTimes = {};
    for (var prayer in prayerTimeOrder) {
      if (prayerTimes.containsKey(prayer)) {
        // Convert dynamic values to String
        sortedPrayerTimes[prayer] = prayerTimes[prayer]?.toString() ?? 'N/A';
      }
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],  // Match the start screen's background
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          mosqueName,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.white),
            onPressed: () {
              // You can add functionality to show the location on a map
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mosque name and description section with gradient background
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.blueGrey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mosque Name",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      mosqueName,
                      style: GoogleFonts.poppins(fontSize: 22, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Description",
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      description,
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Mosque location with elevated card design
              Card(
                color: Colors.blueGrey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Latitude: ${mosqueLocation.latitude}",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                      ),
                      Text(
                        "Longitude: ${mosqueLocation.longitude}",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              // Prayer times section
              Text(
                "Prayer Times",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              // Prayer times in elevated cards with a clean layout
              ...sortedPrayerTimes.entries.map((entry) {
                return Card(
                  color: Colors.blueGrey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          entry.value,
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
