import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings", style: GoogleFonts.marcellus(
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)
        )),
        backgroundColor: Colors.blueAccent,

      ),
    );
  }
}
