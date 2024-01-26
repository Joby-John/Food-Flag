import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.brown[200],
          appBar: AppBar(
            /*title: const Text("FOOD FLAG",
              textAlign: TextAlign.center,),
            backgroundColor: Colors.white,
            titleTextStyle: const TextStyle(color: Colors.red,
                fontSize: 32,
                fontFamily: "Georgia",
                fontWeight: FontWeight.bold
            ),*/
            centerTitle: true,
            elevation: 50,
            shadowColor: Colors.white54,
            leading: const Icon(Icons.menu_rounded,
              size: 37,),
            actions:[IconButton(onPressed: (){}, icon: Icon(Icons.search, size: 37,)),],
          ),

      ),
    );
  }
}