import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

class Scan extends StatefulWidget {
   Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan to Authenticate",style: GoogleFonts.marcellus(
        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54))),
        backgroundColor: Colors.lightGreen,
      ),
      body:StreamBuilder<DocumentSnapshot>
        (stream: FirebaseFirestore.instance.collection("users").doc(authState.currentUser?.uid).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot>snapshot)
        {
           if (snapshot.hasError)
             {
               return(Center(
                   child: Text("Something wrong")
               )
               );
             }
           if (snapshot.connectionState == ConnectionState.active)
             {
               Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
               return(Center(
                 child:Column(
                     children:[
                       Text('${data['number']}'),
                       Text('${data['name']}'),
                     ])
               )
               );
             }
           return const
               Center(
             child: Text("loading...."),
           );
        },
      ),
    );
  }
}
