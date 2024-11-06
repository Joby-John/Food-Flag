import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:FoodFlag/services/createMarker.dart';

import 'package:firebase_core/firebase_core.dart';

import '../services/auth.dart';
import 'package:provider/provider.dart';


class QrScan extends StatefulWidget {
  const QrScan({super.key});

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> with SingleTickerProviderStateMixin {
  final TextEditingController _amount = TextEditingController(text: '10');
  final TextEditingController _count = TextEditingController(text: '1');
  String qrCodeText = '';
  String user_uid = '';
  String cause = '';
  int count = 1;
  int amount = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void _processQrCode(String QrText)
  {
    List<String>parts = QrText.split('~');
    if(parts.length == 2)
    {
      user_uid = parts[0];
      cause = parts[1];

      print('$user_uid, $cause');
    }
    else
    {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid QR Code'),
          content: Text('QR code is INVALID!\n Cannot Create Flag' ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _validateAndCreateFlag(String user_uid, int count, int amount, String cause)
  async {
    String errorMessage = '';
    amount = int.tryParse(_amount.text)!;
    count = int.tryParse(_count.text)!;

    if(amount == null || amount<10)
      {
        errorMessage += 'Amount should at least be 10\n';
        setState(() {
          _amount.text = '10';
        });
      }

    if(count == null || count<1)
      {
        errorMessage += 'Count should at least be 1';
        setState(() {
          _count.text = '1';
        });
      }

    if(errorMessage.isNotEmpty)
      {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Input Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    else
      {
          //do the create flag logic here
        //create a for loop of count times each time creating count flags of amount rs
        // final authState = Provider.of<AuthState>(context, listen: false);
        User? restaurant_user = FirebaseAuth.instance.currentUser;


          firestore.FirebaseFirestore.instance.collection('restaurants').doc(restaurant_user?.uid).get().then((firestore.DocumentSnapshot snapshot) async {
            if(snapshot.exists)
            {
              String location = snapshot['location'];
              firestore.GeoPoint rest_location = convertToGeoPoint(location);
              String rest_name = snapshot['name'];
              String rest_phone = snapshot['phone'];
              String rest_id = snapshot['uid'];

              for(int i = 1; i<=count!; i++)
              {
                await addRestaurantMarker(location: rest_location, name: rest_name, phone: rest_phone, cause: cause, amount: amount, rest_id:rest_id, creator_id: user_uid);
              }
            }
            else
            {
              print('failed to find restaurant document');
            }
          }).catchError((error)
            {
              print("Error occurred while getting restaurant document, printed at line 132, rest_qr_scan_page ${error}");
            });

      }
  }

  Future<bool> _checkUID(String qrUID ) async
  {
    try {
      firestore.DocumentSnapshot documentSnapshot = await firestore.FirebaseFirestore.instance.collection('users').doc(qrUID).get();
      if(documentSnapshot.exists)
        {
          print(documentSnapshot['name']);
          return true;
        }
      else
        {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Cannot create marker'),
                content: Text('User not found in the database'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
          );
          return false;
        }

    }
    catch(e)
    {
      print('error occurred $e');
      return false;
    }
  }

  firestore.GeoPoint convertToGeoPoint(String location) {
    // Assuming `location` is in the format "latitude,longitude"
    List<String> coordinates = location.split(',');
    if (coordinates.length == 2) {
      double latitude = double.parse(coordinates[0].trim());
      double longitude = double.parse(coordinates[1].trim());
      return firestore.GeoPoint(latitude, longitude);
    } else {
      throw FormatException('Invalid location format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Qr"),
        centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
          Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(12),
          width: 300,
          height: 300,
          child: Stack(
            children: [
              MobileScanner(
                controller: MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates),
                onDetect: (capture) {
                  // Handle QR code detection here
                  final List<Barcode>barcodes = capture.barcodes;
                  if(barcodes.isNotEmpty)
                    {
                      setState(() {
                        qrCodeText = barcodes.first.rawValue ?? 'Unknown';
                      });
                      print(qrCodeText);
                    }
                },
              ),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.lightGreen,
                    width: 4.0,
                  ),
                ),
              ),
            ],
          ),
                ),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: 210,
                child: TextField(
                  controller: _amount,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.money, size: 33),
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(12.0),
                width: 210,
                child: TextField(
                  controller: _count,

                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.numbers_rounded, size: 33),
                    labelText: 'Enter Count',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                ),
              ),
              Container(
                width: 160,
                child: FloatingActionButton(
                  onPressed: () async {
                    _processQrCode(qrCodeText);
                    if(await _checkUID(user_uid))
                      {
                        _validateAndCreateFlag(user_uid, count, amount, cause);
                      }
                    else
                      {
                        print("No such user in database");
                      }

                  },
                  child: Text("Create Flag"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}