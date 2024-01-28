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
                    leading: Icon(Icons.flag_circle_rounded,size: 39,color: Colors.red[200],),
                    title: Text('H o i s t    F l a g', style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                        ),


                ListTile(
                  onTap: (){/* Function call for dashboard here*/},
                  leading: Icon(Icons.dashboard,size: 39,color: Colors.white70),
                    title: Text('D a s h b o a r d', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                  ),


                ListTile(onTap: (){/* Function call qr code scanner here*/},
                  leading: Icon(Icons.qr_code_scanner_rounded,size: 39,color: Colors.black45),
                  title: Text('S c a n', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                ),


                ListTile(onTap: (){/* Function call settings page here*/},
                  leading: Icon(Icons.settings,size: 39,color: Colors.grey),
                  title: Text('S e t t i n g s', style: GoogleFonts.marcellus(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),),
                ),





    ],//children
    ),
    );
  }
}
