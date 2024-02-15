import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class Caughtflag extends StatefulWidget {
  const Caughtflag({super.key});

  @override
  State<Caughtflag> createState() => _CaughtflagState();
}

class _CaughtflagState extends State<Caughtflag> {
  @override
  late String? flag_type; // to be updated from server
  //DateTime current_time = DateTime.now();
  DateTime catch_before = DateTime
      .now(); // cant just add 30 minutes, either implement a timer or fixed time
  late String?code; //code should be only revealed when he reaches vicinity of hotel(code not for individuals)
  late String? username;
  late int? amount;
  late String? mealType;
  @override
  void initState() {
    super.initState();
    flag_type = null;
    code = null;
    username = null;
    amount = null;
    mealType = null;

    getOwner(); // Call the getOwner function when the widget is initialized
  }

  Future<void> getOwner() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    String user = authState.currentUser!.uid;
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user).get();
      if (userDoc.exists) {
        String og_user = "";
        String og_marker = "";
        // Access the data in the received field
        Map<String, dynamic> receivedData = userDoc['received'];
        // Now you can access the key-value pairs in the received field
        receivedData.forEach((key, value) {
          print("$key, $value");
          og_user = key;
          og_marker = value;
          // Do something with each key-value pair
        });

        // Read the marker document
        DocumentReference markerRef = FirebaseFirestore.instance
            .collection('users')
            .doc(og_user)
            .collection('markersDoc')
            .doc(og_marker);
        DocumentSnapshot markerDoc = await markerRef.get();
        print("Works till here");
        if (markerDoc.exists) {
          print({markerDoc['origin']});
          print({code = markerDoc['code']});
          setState(
            () {
              flag_type = markerDoc['origin'];
              code = markerDoc['code'];
              username = markerDoc['name'];
              amount = markerDoc['amount'];
              mealType = markerDoc['type'];
            },
          );
        } else {
          print("marker doc doesn't exist");
        }
      } else {
        print('User document does not exist.');
      }
    } catch (error) {
      print('Error getting user document: $error');
      setState(
        () {
          flag_type = 'Unknown';
          code = 'Unknown';
          username = 'Unknown';
          amount = 0;
          mealType = "Unknown";
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Caught Flag",
                style: GoogleFonts.volkhov(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54))),

            ListTile(
              title: Text(
                'Flag Type : $flag_type',
                style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
            ),
            ListTile(
              title: Text(
                'Meal Type : $mealType',
                style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
            ),

            // ListTile(title: Text('Reach Before : $catch_before', style: GoogleFonts.marcellus(
            //     textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),),
            // ),

            ListTile(
              title: Text(
                'User Name : $username',
                style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
            ),

            ListTile(
              title: Text(
                'Code : $code',
                style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
            ),

            ListTile(
              title: Text(
                'Amount : $amount',
                style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement delete functionality here
                  },
                  child: Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement directions functionality here
                  },
                  child: Text('Directions'),
                ),
              ],
            )
          ],
        )
    );

    String formatTime(DateTime time) {}
  }
}
