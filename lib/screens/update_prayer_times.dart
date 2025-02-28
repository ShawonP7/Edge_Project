import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPrayerTimesScreen extends StatefulWidget {
  final Map<String, dynamic> mosque;
  const EditPrayerTimesScreen({Key? key, required this.mosque}) : super(key: key);

  @override
  _EditPrayerTimesScreenState createState() => _EditPrayerTimesScreenState();
}

class _EditPrayerTimesScreenState extends State<EditPrayerTimesScreen> {
  final TextEditingController _fajrController = TextEditingController();
  final TextEditingController _dhuhrController = TextEditingController();
  final TextEditingController _asrController = TextEditingController();
  final TextEditingController _maghribController = TextEditingController();
  final TextEditingController _ishaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  // ✅ Load Current Prayer Times into Input Fields
  void _loadPrayerTimes() {
    var times = widget.mosque["prayer_times"];
    _fajrController.text = times["Fajr"] ?? "00:00 AM";
    _dhuhrController.text = times["Dhuhr"] ?? "00:00 PM";
    _asrController.text = times["Asr"] ?? "00:00 PM";
    _maghribController.text = times["Maghrib"] ?? "00:00 PM";
    _ishaController.text = times["Isha"] ?? "00:00 PM";
  }

  // ✅ Update Firestore with New Prayer Times
  Future<void> _updatePrayerTimes() async {
    await FirebaseFirestore.instance.collection("mosques").doc(widget.mosque["id"]).update({
      "fajr": _fajrController.text.trim(),
      "dhuhr": _dhuhrController.text.trim(),
      "asr": _asrController.text.trim(),
      "maghrib": _maghribController.text.trim(),
      "isha": _ishaController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Prayer times updated successfully!")),
    );

    Navigator.pop(context); // ✅ Return to Mosque Details Screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Prayer Times")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _fajrController, decoration: InputDecoration(labelText: "Fajr")),
            TextField(controller: _dhuhrController, decoration: InputDecoration(labelText: "Dhuhr")),
            TextField(controller: _asrController, decoration: InputDecoration(labelText: "Asr")),
            TextField(controller: _maghribController, decoration: InputDecoration(labelText: "Maghrib")),
            TextField(controller: _ishaController, decoration: InputDecoration(labelText: "Isha")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePrayerTimes,
              child: Text("Update Prayer Times"),
            ),
          ],
        ),
      ),
    );
  }
}
