import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int flyingflags = 1; // later to take from DB
  int flagdown = 3;
  int flagtransit = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child:Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Dash board" ,style: GoogleFonts.volkhov(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54))),

          ListTile(title: Text('Flying flags : $flyingflags', style: GoogleFonts.marcellus(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),),
      ),


          ListTile(title: Text('Flags taken down : $flagdown ', style: GoogleFonts.marcellus(
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),),
          ),

          ListTile(title: Text('Flags in Transit : $flagtransit ', style: GoogleFonts.marcellus(
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),),
          ),



        ],//children
      )
    );
  }
}
