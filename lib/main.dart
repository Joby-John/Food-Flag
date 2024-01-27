import 'package:flutter/material.dart';
import 'package:FoodFlag/pages/map_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: const MapPage(),
        appBar: AppBar( title: Text('Food Flag', style: GoogleFonts.libreBaskerville(
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ,),centerTitle: false,
          backgroundColor: const Color.fromARGB(200, 55, 149, 112),
          leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu_rounded, size: 33)),
          actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search, size: 33,))],

        ),
      ),
    );
  }
}