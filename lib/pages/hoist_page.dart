import 'package:FoodFlag/services/createMarker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:FoodFlag/pages/map_page.dart';

import '../services/auth.dart';

class Hoist extends StatefulWidget {
  const Hoist({Key? key});

  @override
  State<Hoist> createState() => _HoistState();
}

class _HoistState extends State<Hoist> {
  String _mealType = "veg";
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Location location = Location();
    currentLocation = await location.getLocation();
    setState(() {});
    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
      });
    });
  }

  Future<void> savetoDB(
      String userId,
      String markerId,
      String mealType,
      String name,
      double latitude,
      double longitude,
      ) async {
    try {
      DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userId);

      DocumentSnapshot userDoc = await userRef.get();

      Map<String, dynamic> markersMap = userDoc['markers'] ?? {};

      markersMap[markerId] = {'latitude': latitude, 'longitude': longitude};

      await userRef.update({'markers': markersMap});

      print('markers added to user document');

      // creating marker document with same geopoint
      await FirebaseFirestore.instance.collection('markers').add(
        {
          'name': name,
          'type': mealType,
          'coordinates': GeoPoint(latitude, longitude),
        },
      );
      print("new marker document created");
    } catch (e) {
      print('Error adding marker:$e');
    }

    print('Selected type:$_mealType');
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    User? user = authState.currentUser;
    String name = "";
    String phone = "";
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 241, 236),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Hoist Flag",
          style: GoogleFonts.marcellus(
              textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        backgroundColor: const Color.fromARGB(255, 46, 204, 113),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select the meal type:",
              style: GoogleFonts.marcellus(
                  textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
            ),
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
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final currentLocation = this.currentLocation;
                  if (currentLocation != null) {
                    try {
                      // Retrieve user's name from Firestore
                      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
                      if (snapshot.exists) {
                        String userName = snapshot['name'];
                        String userPhone = snapshot['phone'];
                        setState(() {
                          name = userName; // Assign the value to the class-level variable
                          phone = userPhone;
                        });
                      } else {
                        print('Document does not exist in the database');
                      }

                      // Call the addMarker function
                      await addMarker(
                        GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
                        _mealType, name,phone,"Self-prepared", 0, '');//cause is made empty string
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Flag hoisted successfully')),
                      );
                    } catch (error) {
                      print('Error: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Flag hoist unsuccessful ! Try Again')),
                      );
                    }
                  } else {
                    print("Current location is null");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Flag hoist unsuccessful ! Try Again')),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 213, 245, 227),
                ),
                child: const Text("Raise a Flag"),
              ),
            ),
            const SizedBox(height: 40,),
            Center(
              child: Text(
                "OR",
                style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
            ),
            const SizedBox(height: 40,),
            Text(
              "Scan QR of the restaurant:",
              style: GoogleFonts.marcellus(
                  textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
            ),
            const SizedBox(height: 40,),
            Center(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/displayUserQr');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 213, 245, 227),
                ),
                child: const Text('Pay and Raise'),
              ),
            ),
            const SizedBox(height: 120,),
            Text(
              "Note: Please don't raise money for multiple meals in "
                  "a single flag, For multiple meals raise multiple flags.",
              style: GoogleFonts.marcellus(
                  textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
            ),
          ],
        ),
      ),
    );
  }
}
