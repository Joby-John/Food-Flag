import 'package:FoodFlag/pages/caught_flag.dart';
import 'package:FoodFlag/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
        backgroundColor: Color.fromARGB(220, 55, 135, 112),
          child: Column(
              children: [const UserAccountsDrawerHeader(
                accountName: Text('Joby',), accountEmail: Text('joby@gmail.com'),
                decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[Colors.green, Colors.lightGreen])) ,),
                //all icons in drawer is in here
                ListTile(
                    onTap: (){/*function call to hoist flag page here*/},
                    leading: Icon(Icons.flag_circle_rounded,size: 39,color: Colors.pinkAccent,),
                    title: Text('H o i s t    F l a g', style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                        ),


                ListTile(
                  onTap: (){ showModalBottomSheet(context: context,
                      builder: (BuildContext context) {
                    return Dashboard();
                      },);},
                  leading: Icon(Icons.dashboard,size: 39,color: Colors.white70),
                    title: Text('D a s h b o a r d', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                  ),

                ListTile(onTap: (){showModalBottomSheet(context: context,
                    builder: (BuildContext context) {
                  return Caughtflag();
                    },);},
                  leading: Icon(Icons.flag,size: 39,color: Colors.lightGreen),
                  title: Text('C a u g h t  F l a g', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                ),


                ListTile(onTap: (){Navigator.pushNamed(context, '/scanpage');},
                  leading: Icon(Icons.qr_code_scanner_rounded,size: 39,color: Colors.black45),
                  title: Text('S c a n', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                ),


                ListTile(onTap: (){/* Function call for message here*/},
                  leading: Icon(Icons.messenger,size: 39,color: Colors.grey),
                  title: Text('M e s s a g e s', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                ),


                ListTile(onTap: (){Navigator.pushNamed(context, '/settingspage');},
                  leading: Icon(Icons.settings,size: 39,color: Colors.grey),
                  title: Text('S e t t i n g s', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                ),




    ],//children
    ),
    );
  }
}
