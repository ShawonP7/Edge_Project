import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mosqueNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  LatLng? _selectedLocation;
  String _locationName = "Select Mosque Location";

  // ✅ Select Location
  void _pickLocation(LatLng newLocation) async {
    setState(() {
      _selectedLocation = newLocation;
      _locationName = "Loading...";
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(newLocation.latitude, newLocation.longitude);
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

  // ✅ Sign-Up Function
  Future<void> _signUp() async {
    if (_selectedLocation == null) {
      Fluttertoast.showToast(msg: "Please select a mosque location", backgroundColor: Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("mosques").doc(user.uid).set({
          "imam_email": _emailController.text.trim(),
          "mosque_name": _mosqueNameController.text.trim(),
          "description": _descriptionController.text.trim(),
          "location": {
            "latitude": _selectedLocation!.latitude,
            "longitude": _selectedLocation!.longitude
          },
        });

        Fluttertoast.showToast(msg: "Registration Successful!", backgroundColor: Colors.green);

        // ✅ Redirect to Login Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Sign-Up Failed", backgroundColor: Colors.red);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Imam Sign Up",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Email Field
            _buildLabel("Email"),
            _buildTextField(controller: _emailController, hintText: "Enter your email", icon: Icons.email),

            SizedBox(height: 20),

            // ✅ Password Field
            _buildLabel("Password"),
            _buildPasswordField(),

            SizedBox(height: 20),

            // ✅ Mosque Name Field
            _buildLabel("Mosque Name"),
            _buildTextField(controller: _mosqueNameController, hintText: "Enter mosque name", icon: Icons.mosque),

            SizedBox(height: 20),

            // ✅ Mosque Description Field
            _buildLabel("Mosque Description"),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Describe your mosque...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.blueGrey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            // ✅ Mosque Location Picker
            _buildLabel("Mosque Location"),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                _showLocationPicker(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _locationName,
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(Icons.location_on, color: Colors.tealAccent),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // ✅ Sign-Up Button
            Center(
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.tealAccent)
                  : ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700],
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Show Map for Selecting Location
  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 400,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(23.8103, 90.4125),
            initialZoom: 14.0,
            onTap: (tapPosition, point) {
              _pickLocation(point);
              Navigator.pop(context);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper Methods
  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 5),
    child: Text(text, style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
  );

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.tealAccent),
        hintText: hintText,
        filled: true,
        fillColor: Colors.blueGrey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField() => _buildTextField(controller: _passwordController, hintText: "Enter password", icon: Icons.lock);
}
