import 'package:FoodFlag/pages/drawer.dart';
import 'package:flutter/material.dart';
import 'package:FoodFlag/pages/map_page.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: const MapPage(),
      appBar: AppBar( title: Text('Food Flag', style: GoogleFonts.libreBaskerville(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        ,),centerTitle: false,
        backgroundColor: const Color.fromARGB(200, 55, 149, 112),

      ),
      drawer: const AppDrawer()
    );
  }
}
