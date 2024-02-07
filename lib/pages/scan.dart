import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag:"scan",
          child:Text("Scan to Authenticate",style: GoogleFonts.marcellus(
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54))),
        ),
        backgroundColor: Colors.lightGreen,
      ),
    );
  }
}
