import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Caughtflag extends StatefulWidget {
  const Caughtflag({super.key});

  @override
  State<Caughtflag> createState() => _CaughtflagState();
}

class _CaughtflagState extends State<Caughtflag> {
  @override
  String flag_type = "Restaurant";// to be updated from server
  DateTime current_time = DateTime.now();
  DateTime catch_before = DateTime.now();// cant just add 30 minutes, either implement a timer or fixed time
  String code = "Will be revealed as you reach location";//code should be only revealed when he reaches vicinity of hotel(code not for individuals)

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Caught Flag" ,style: GoogleFonts.volkhov(
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54))),

            ListTile(title: Text('Flag Type(Ind/rest/fun) : $flag_type', style: GoogleFonts.marcellus(
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),),
            ),


            ListTile(title: Text('Reach Before : $catch_before', style: GoogleFonts.marcellus(
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),),
            ),

            ListTile(title: Text('Code : $code', style: GoogleFonts.marcellus(
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),),
            ),



          ],//children
        )
    );

    String formatTime(DateTime time)
    {

    }
  }
}
