import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late String? phone;
  late String? uid;
  late int? amount;
  late String? mealType;
  late String? og_marker;
  late GeoPoint? location;
  late String? og_user;
  late String? cause;
  late DocumentSnapshot userDoc;

  late AuthState authState;
  late User? user;
  late String userId;
  @override
  void initState() {
    super.initState();
    flag_type = null;
    code = null;
    username = null;
    phone = null;
    amount = null;
    mealType = null;
    location =  null;
    og_marker = null;
    uid = null;
    cause = '';

    authState = Provider.of<AuthState>(context, listen: false);
    user = authState.currentUser;
    userId = user!.uid;

    getOwner(); // Call the getOwner function when the widget is initialized
  }

  Future<void> getOwner() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    String user = authState.currentUser!.uid;
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user).get();
      if (userDoc.exists) {
        og_user = "";
        og_marker = "";
        // Access the data in the received field
        Map<String, dynamic> receivedData = userDoc['received'];
        // Now you can access the key-value pairs in the received field
        receivedData.forEach((key, value) {
          print("$key, $value");
          setState(() {
            og_user = key;
            og_marker = value;
          });
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
              phone = markerDoc['phone'];
              amount = markerDoc['amount'];
              mealType = markerDoc['type'];
              location = markerDoc['location'];
              og_marker = markerDoc['code'];
              cause = markerDoc['cause'];
            },
          );
        } else {
          print("marker doc doesn't exist");
          setState(
                  () {
                flag_type = "";
                code = "";
                username = "";
                amount = 0;
                mealType = "";
                location = null;
              }
          );
        }
      } else {
        print('User document does not exist.');
      }
    } catch (error) {
      print('Error getting user document: $error');
      setState(
        () {
          flag_type = 'No Flags here!';
          code = '';
          username = '';
          phone = null;
          amount = 0;
          mealType = "";
        },
      );
    }
  }

  void _showQrCodeDialog( BuildContext context, String code, String my_UID, String issuer_uid)
  {
    //myUID to check hsi documents caught flag to verify, hes the right owner, not the screenshot cheater,
    //issuer UID is for restaurants, to verify whether the flag was created by that restaurant itself
    showDialog(context: context, builder: (BuildContext context)
    {
      return AlertDialog(
        contentPadding: EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("QR Code", style: GoogleFonts.volkhov(
                            textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,),
                            ),
            ),
            const SizedBox(height: 10,),
            QrImageView(data: '${my_UID}~${code}~${issuer_uid}',
                        version:QrVersions.auto,
                        size: 200.0,),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("Close"))
          ],
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // mainAxisSize: MainAxisSize.max,
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
                'Flag Cause : $cause',
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
                
            ElevatedButton(onPressed: (){
              if( code != null && code!.isNotEmpty)
                {
                  _showQrCodeDialog(context, code!, userId!, og_user!);
                }
              else
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No code Available"))
                  );
                }
            }, child: Text("Show Secret Code")),


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
                  onPressed: () async {
                    final authState = Provider.of<AuthState>(context, listen: false);
                    String user = authState.currentUser!.uid;

                    if (og_marker != null) {
                      Map<String, dynamic> markerData = {
                        'location': location,
                        'type': mealType,
                        'amount': amount,
                        'origin': flag_type,
                        'uid': og_user,
                        'cause': cause,
                      };

                      try {
                        await FirebaseFirestore.instance.collection('users').doc(og_user).update({
                          'markers.$og_marker': markerData,
                        });
                        print("Delete working");

                        print(user);
                        await FirebaseFirestore.instance.collection('users').doc(og_user).update({'runningFlags.$userId':FieldValue.delete()});

                        await FirebaseFirestore.instance.collection('users').doc(user).update({
                          'received.$og_user': FieldValue.delete(),
                        });
                      } catch (error) {
                        print('Error updating documents: $error');
                      }
                    } else {
                      print('Error: og_marker is null.');
                    }
                    setState(() {
                      // Update the state variables that may have changed
                      flag_type = '';
                      code = '';
                      cause = '';
                      username = '';
                      phone = null;
                      amount = 0;
                      mealType = '';
                      location = null;
                      og_marker = null;

                    });

                  },

                  child: Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Implement directions functionality here

                    if (location!= null) {
                      // Google Maps URL with the destination coordinates
                      final url = 'https://www.google.com/maps/dir/?api=1&destination=${location!.latitude},${location!.longitude}';

                      if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                    } else {
                    throw 'Could not launch $url';
                    }
                    } else {
                    // Handle the case where location data is not available
                    // For example, display an error message or take appropriate action
                    }
                  },
                  child: Text('Directions'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (phone!=null){
                      final String url = 'tel:$phone';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                        } else {
                       throw 'Could not launch $url';
                      }
                   }

                  },
                  child: Text('Call'),
                ),
                
              ],
            )
          ],
        )
    );

    String formatTime(DateTime time) {}
  }
}
