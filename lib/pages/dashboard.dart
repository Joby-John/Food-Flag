import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AuthState authState;
  late User? user;
  late String userId;
  late DocumentReference userRef;
  late DocumentSnapshot userDoc; // Declare userDoc as a class-level variable
  int donated = 0;
  int running = 0;
  int flying = 0;
  late String enteredCode = '';

  late DocumentReference catcherRef;
  late DocumentSnapshot catcherDoc;

  @override
  void initState() {
    super.initState();
    authState = Provider.of<AuthState>(context, listen: false);
    user = authState.currentUser;
    userId = user!.uid;
    userRef = FirebaseFirestore.instance.collection('users').doc(userId);
    getFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Dashboard",
                  style: GoogleFonts.volkhov(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          enteredCode = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Last 5 characters of code...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(37)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: verify,
                    child: Text('Verify'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(thickness: 1,),
              SizedBox(height: 5),
              ListTile(
                title: Text(
                  'Total Donated: $donated',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 1,),
              SizedBox(height: 5),
              ListTile(
                title: Text(
                  'Flying Flags: $flying',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 1,),
              SizedBox(height: 5),
              ListTile(
                title: Text(
                  'Running Flags: $running',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
              ),

      
              // Add more widgets here
            ],
          ),
        );
  }

  Future<void> getFromDB() async {
    try {
      userDoc = await userRef.get(); // Assign the value of userDoc
      setState(() {
        donated = userDoc['donated'];
        running = userDoc['runningFlags'].length;
        flying = userDoc['markers'].length;
      });
    } catch (e) {
      print('Error getting data from database: $e');
    }
  }

  void verify() {
    print('Entered code: $enteredCode');
    print('Current user ID: $userId');
    // Access userDoc as needed

    // Access the flyingFlags map from userDoc
    Map<String, dynamic> runningFlags = userDoc['runningFlags'];

    // Iterate through each key-value pair in the flyingFlags map
    runningFlags.forEach((key, value) {
      // Extract the last 5 characters of the key
      String lastFiveCharacters = value.substring(value.length - 5);

      // Check if the last 5 characters of the key match the entered code
      if (lastFiveCharacters == enteredCode) {
        // Match found, perform desired action
        print('Match found for code: $enteredCode');
        print('Key: $key, Value: $value');
        // You can perform additional actions here

        Delete(key, value);
      }
    });
  }

  Future<void> Delete(String key, String value) async {
    List<String> parts = value.split('_');
    String owner = parts[0];// in our case its same as current user
    String markerId = parts[1];
    String catcher = key;
    // delete catchers received
    catcherRef = FirebaseFirestore.instance.collection('users').doc(catcher);
    try {
      await catcherRef.update({'received.$owner':FieldValue.delete(),});

      // delete owners runningFlags nd that marker from his markers collection
      await userRef.update({'runningFlags.$owner':FieldValue.delete()});
      await userRef.collection('markersDoc').doc(markerId).delete();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        if (userDoc.exists) {
          int donated = userDoc['donated'] ?? 0;
          transaction.update(FirebaseFirestore.instance.collection('users').doc(owner), {'donated': donated + 1});
        }
      });
    } catch (e) {
      print('Error deleting : $e');
    }

  }
}
