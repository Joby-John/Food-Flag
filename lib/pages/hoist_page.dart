import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Hoist extends StatefulWidget {
  const Hoist({super.key});

  @override
  State<Hoist> createState() => _HoistState();
}

class _HoistState extends State<Hoist> {

  String _mealType = "veg";

  void _savetoDB()
  {
    print('Selected type:$_mealType');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242,241,236),
      appBar: AppBar( centerTitle: true,
        title: Text("Hoist Flag", style: GoogleFonts.marcellus(
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)
        )),
        backgroundColor: const Color.fromARGB(255, 46,204,113),

      ),
      body: Padding(padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select the meal type:",style:GoogleFonts.marcellus(
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)
          ),),
          RadioListTile(
          title: const Text("Vegetarian"),
            value: "veg",
            groupValue: _mealType,
            onChanged: (value) {
            setState(() {
              _mealType = value as String;
            });
            },
        ),

        RadioListTile(
          title: const Text("Non-Vegetarian"),
          value: "non-veg",
          groupValue: _mealType,
          onChanged: (value) {
            setState(() {
              _mealType = value as String;
            });
          },
        ),

          const SizedBox(height: 20,),
          Center(child: ElevatedButton(onPressed: _savetoDB,
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255,213,245,227),),
            child: const Text("Raise a Flag")
          ,)),


          const SizedBox(height: 40,),
          Center(child: Text("OR", style:GoogleFonts.marcellus(
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)
          ),)),
          const SizedBox(height: 40,),
          Text("Scan QR of the restaurant:", style:GoogleFonts.marcellus(
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)
          ),),
          const SizedBox(height: 40,),
          Center(child: ElevatedButton(onPressed: (){},
            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255,213,245,227),),
              child: const Text('Pay and Raise'),)),
          const SizedBox(height: 120,),
          Text("Note: Please don't raise money for multiple meals in "
              "a single flag, For multiple meals raise multiple flags.", style:GoogleFonts.marcellus(
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)
          ),),
        ],
      ),
      ),
    );
  }
}
