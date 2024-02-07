import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Hoist extends StatefulWidget {
  const Hoist({super.key});

  @override
  State<Hoist> createState() => _HoistState();
}

class _HoistState extends State<Hoist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( centerTitle: true,
        title: Hero(
          tag:"hoist",
          child: Text("Hoist Flag", style: GoogleFonts.marcellus(
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)
        )),
        ),
        backgroundColor: Colors.lightGreen,

      ),
    );
  }
}
