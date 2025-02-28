import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import 'login_screen.dart';
import 'user_home_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ App Logo (Change the Asset if Needed)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 3),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                ),
              ),

              SizedBox(height: 20),

              // ✅ App Title
              Text(
                "Prayer Time App",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 5),

              // ✅ Subtitle
              Text(
                "Find Nearby Mosques & Prayer Times",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // ✅ Imam Button
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedElevation: 5,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                closedColor: Colors.blueAccent,
                openBuilder: (context, _) => LoginScreen(),
                closedBuilder: (context, openContainer) => Container(
                  width: 200,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.blue[700]!, blurRadius: 10, spreadRadius: 1),
                    ],
                  ),
                  child: Text(
                    "Imam",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // ✅ Muqtadi Button
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedElevation: 5,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                closedColor: Colors.tealAccent[700]!,
                openBuilder: (context, _) => UserHomeScreen(),
                closedBuilder: (context, openContainer) => Container(
                  width: 200,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.tealAccent[700],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.teal[700]!, blurRadius: 10, spreadRadius: 1),
                    ],
                  ),
                  child: Text(
                    "Muqtadi",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 40),

              // ✅ Footer Text
              Text(
                "Made with ❤️ for the Muslim Community",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
