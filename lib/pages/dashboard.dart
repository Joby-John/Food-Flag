import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
  late String qrText = '';

  //qrExtract variables

  late String flag_type = '';
  late String his_UID = '';
  late String enteredCode = '';
  late String issuer_UID = '';
  late String restaurant_id = '';

  //verifying vars by looking into his documents received
  late String his_received_UID = '';
  late String his_received_code = '';


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

    userRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          donated = snapshot['donated'];
          running = snapshot['runningFlags'].length;
          flying = snapshot['markers'].length;
        });
      }
    });
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

              SizedBox(width: 20),
              ElevatedButton(
                onPressed: (){_showQrScanner(context);},
                child: Text('Scan and Verify'),
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

  void _showQrScanner(BuildContext context)
  {
    showDialog(context: context , builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Scan and Verify", style: GoogleFonts.volkhov(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,),
                  ),
                  ),
                  Container(
                    height: 300,
                    width: 300,
                    padding: EdgeInsets.all(12),
                    child: MobileScanner(

                      controller: MobileScannerController(),
                      onDetect: (capture) {
                        final List<Barcode>barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final String? rawValue = barcodes.first.rawValue;

                          if (rawValue != null) {
                            setState(() {
                              qrText = rawValue;
                            });
                          }
                          else{
                            qrText = '';
                          }
                        }
                      },

                    ),
                  ),
                  Text(qrText == '' ? "No QR Found" : "Found a Qr Code"),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(onPressed: () {
                        verify(qrText);
                      }, child: Text('Verify')),
                      ElevatedButton(onPressed: () {
                        setState((){
                          qrText = '';
                          flag_type = '';
                          his_UID = '';
                          enteredCode = '';
                          issuer_UID = '';
                          restaurant_id = '';
                        });
                        Navigator.of(context).pop();
                      }, child: Text('Cancel'))
                    ],
                  )

                ],

              ),

            );
          });
    });
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

  Future<void> verify( String qrText) async {
    //Things to verify before allowing and deleting flag
    //check whether flag is in users running flag
    //check whether flag is 'Self-origin' if not say you cannot verify restaurant flags even if you raised them
    //check the redeemers received to check if its there, to prevent screenshot.
    //only if all these match start delete.
    extractQRData(qrText);
    print('Entered code: $enteredCode');
    print('Current user ID: $userId');
    // Access userDoc as needed

    if(flag_type == 'Self-prepared') {

      if(await verifyCatcher(his_UID)) {
        print("marker is present in his received");
        // Access the flyingFlags map from userDoc
        Map<String, dynamic> runningFlags = userDoc['runningFlags'];

        // Iterate through each key-value pair in the flyingFlags map
        runningFlags.forEach((key, value) {

          // Split the value on "_"
          List<String> parts = value.split('_');
          print("Splitted");
          // Check if there are at least two parts to avoid index errors
          if (parts.length >= 2) {
            String extractedCode = parts[1]; // Access the second part, which is the code
            print('Got $extractedCode');

            // Check if extracted code matches the entered code
            if (extractedCode == enteredCode) {
              print(enteredCode);
              print("Matches the entered code");
              // Match found, perform desired action
              print('Match found for code: $enteredCode');
              print('Key: $key, Value: $value');

              // Perform the Delete operation
              Delete(issuer_UID, his_UID);
            }
          }
            else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Verification Status'),
                    content: Text('Invalid Code'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }

        });
      }
      else
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Unauthorized Flag'),
                content: Text("This Flag doesn't exist in your profile"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
    }
    else if(flag_type == 'restaurant')
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cannot Redeem Restaurant Flag'),
              content: Text('Only issued Restaurant can verify Restaurant Flag'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
  }

  Future<bool> verifyCatcher(String catcher_uid)
  async {
    try{
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(catcher_uid).get();
      if(userDoc.exists)
      {
        Map<String, dynamic> receivedData = userDoc['received'];
        // Now you can access the key-value pairs in the received field
        receivedData.forEach((key, value) {
          print("$key, $value");
          setState(() {
            his_received_UID = key;
            his_received_code = value;
          });
      });
        return(his_received_code == enteredCode);
    }
      else{
        return false;
      }

    }
    catch(e)
    {
      print("Error finding the claimers document $e");
      return false;
    }
  }

  void extractQRData(String QrText)
  {
    List<String> parts = qrText.split('~');

    // Check if there are exactly 5 parts to avoid errors
    if (parts.length == 5) {
      setState(() {
        flag_type = parts[0];
        his_UID = parts[1];
        enteredCode = parts[2];
        issuer_UID = parts[3];
        restaurant_id = parts[4];
      });

      print("Flag Type: $flag_type");
      print("His UID: $his_UID");
      print("Entered Code: $enteredCode");
      print("Issuer UID: $issuer_UID");
      print("Restaurant ID: $restaurant_id");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid QR Code'),
            content: Text('The QR code format is invalid. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print("Invalid QR code format");

    }
  }

  Future<void> Delete(String issuer_UID, String catcher_UID) async {

    String markerId = enteredCode;
    String catcher = catcher_UID;
    // delete catchers received
    catcherRef = FirebaseFirestore.instance.collection('users').doc(catcher);
    try {
      await catcherRef.update({'received.$issuer_UID':FieldValue.delete(),});
      print("Deleted received of $catcher with $issuer_UID");

      // delete owners runningFlags nd that marker from his markers collection
      await userRef.update({'runningFlags.$catcher':FieldValue.delete()});
      print('Deleted running of $issuer_UID with $catcher');

      await userRef.collection('markersDoc').doc(markerId).delete();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        if (userDoc.exists) {
          int donated = userDoc['donated'] ?? 0;
          transaction.update(FirebaseFirestore.instance.collection('users').doc(issuer_UID), {'donated': donated + 1});
        }
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Verification Status'),
            content: Text('Successfully Verified'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    qrText = '';
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

    } catch (e) {
      print('Error deleting : $e');
    }

  }
}
