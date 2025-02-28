import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'imam_dashboard.dart'; // Imam Dashboard Screen
import 'user_home_screen.dart'; // Muqtadi (User) Screen
import 'sign_up_screen.dart'; // Sign-Up Screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // ✅ Firebase Login Function (Direct to Imam Dashboard)
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Fluttertoast.showToast(msg: "Login Successful", backgroundColor: Colors.green);

      // ✅ Redirect to Imam Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ImamDashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Login Failed", backgroundColor: Colors.red);
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
        actions: [
          // ✅ Muqtadi Button (Top Right Corner)
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserHomeScreen()),
              );
            },
            child: Text(
              "Muqtadi",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ App Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 1),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset("assets/logo.png", fit: BoxFit.cover),
                  ),
                ),

                SizedBox(height: 15),

                // ✅ Title
                Text(
                  "Welcome Imam!",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 5),

                // ✅ Subtitle
                Text(
                  "Log in to manage your mosque",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),

                SizedBox(height: 30),

                // ✅ Email Field
                _buildTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),

                SizedBox(height: 20),

                // ✅ Password Field
                _buildPasswordField(),

                SizedBox(height: 30),

                // ✅ Login Button (Redirect to Imam Dashboard)
                _isLoading
                    ? CircularProgressIndicator(color: Colors.tealAccent)
                    : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent[700],
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // ✅ Sign Up Button (Below Login Button)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    "Create an Account",
                    style: TextStyle(
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Reusable TextField Widget
  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.tealAccent),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.blueGrey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ✅ Password Field with Show/Hide Toggle
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.tealAccent),
        hintText: "Enter your password",
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.blueGrey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
