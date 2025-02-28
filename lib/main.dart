import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/start_screen.dart';

// ✅ Ensure Firebase initializes differently for Web and Mobile
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase for Web
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBJY8eXLCdhCYUb-73vqFkIdY_b2qj1uKk",
        authDomain: "prayer-time-8f5e1.firebaseapp.com",
        projectId: "prayer-time-8f5e1",
        storageBucket: "prayer-time-8f5e1.appspot.com",
        messagingSenderId: "881338916859",
        appId: "1:881338916859:web:02b1f146451196f0d0f55e",
        measurementId: "G-JLLQNPDXV8",
      ),
    );
  } else {
    // ✅ Initialize Firebase for Android & iOS (Defaults from `google-services.json`)
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prayer Time App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StartScreen(), // ✅ Loads StartScreen First
    );
  }
}
