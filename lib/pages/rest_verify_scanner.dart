import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';



class VerifyScan extends StatefulWidget {
  const VerifyScan({super.key});

  @override
  State<VerifyScan> createState() => _VerifyScanState();
}

class _VerifyScanState extends State<VerifyScan> with SingleTickerProviderStateMixin {
  late MobileScannerController _cameraController = MobileScannerController();
  String flag_type = '';
  String receiver_id = '';
  String marker_id = '';
  String creator_id = '';
  String rest_id = '';
  String qrCodeText = '';

  late int amount;
  User? restaurant_user = FirebaseAuth.instance.currentUser;

  //snapshots
  late firestore.DocumentSnapshot receiverSnapshot;
  late firestore.DocumentSnapshot restaurantSnapshot;



  @override
  void initState() {
    super.initState();
    _cameraController.start();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  bool _processQrCode(String QrText)
  {
    List<String>parts = QrText.split('~');
    if(parts.length == 5)
    {
       flag_type =  parts[0];
       if(flag_type!='restaurant')
         {
           showDialog(context: context, builder: (builder)=>AlertDialog(
             title: Text('QR Code Not Recognized'),
             content: Text('This QR Code is not related to food flag'),
             actions: [
               TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
             ],
           ));
           return false;
         }
       receiver_id = parts[1];
       marker_id = parts[2];
       creator_id = parts[3];
       rest_id = parts[4];

      print('$flag_type, $receiver_id, $marker_id, $creator_id, $rest_id');
      return true;
    }
    else
    {
      showDialog(context: context, builder: (builder)=>AlertDialog(
        title: Text('QR Code Not Recognized'),
        content: Text('This QR Code is not related to food flag'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
        ],
      ));
      return false;
    }
  }

  Future<bool> _checkExistence(String receiver_id, String marker_id, String creator_id, String rest_id)
  async {
    try{
      receiverSnapshot = await firestore.FirebaseFirestore.instance.collection('users').doc(receiver_id).get();
      if(receiverSnapshot.exists)
        {
          // Get the received map of the receiver to check if it exists in his received map
          Map<String, dynamic>? receivedMap = receiverSnapshot['received'];

          if (receivedMap != null && receivedMap.isNotEmpty) {
            // Assuming there is only one entry in the map
            String creatorId = receivedMap.keys.first;
            String markerId = receivedMap.values.first;

            if(creatorId == creator_id && markerId == marker_id) //that means the marker is in his received flags and not a screen shot
              {
              restaurantSnapshot = await firestore.FirebaseFirestore.instance.collection('restaurants').doc(rest_id).get();
              if(restaurantSnapshot.exists && restaurant_user?.uid == rest_id)
                {
                  //check his unverified flags
                  Map<String, dynamic>? unverifiedMarkers = restaurantSnapshot['unverifiedMarkers'];

                  // Check if unverifiedMarkers contains the map for the specified marker_id
                  if (unverifiedMarkers != null && unverifiedMarkers.containsKey(marker_id)) {
                    Map<String, dynamic> markerData = unverifiedMarkers[marker_id];

                    // Do something with the markerData here
                    print("Marker data retrieved: $markerData");
                    amount = markerData['amount'];
                    print(amount);
                    //return true as marker is present in every where only place left to check is creators document that'll be done in next function
                    return true;

                  } else {
                    showDialog(context: context, builder: (builder) => AlertDialog(
                      title: Text("Marker Not Found"),
                      content: Text('This Marker is not found in restaurants data'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
                      ],
                    ));
                    return false;
                  }
                }
              else
                {
                  showDialog(context: context, builder: (builder)=>AlertDialog(
                    title: Text("Wrong Restaurant"),
                    content: Text('Shown Marker is not of this restaurant'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
                    ],
                  ));
                  return false;
                }
              }
            else{
              showDialog(context: context, builder: (builder)=>AlertDialog(
                title: Text('Marker Not Found'),
                content: Text('Marker not found in redeemers account'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
                ],
              ));
            }
            return false;
          }
          else
            {
              showDialog(context: context, builder: (builder)=>AlertDialog(
                title: Text('Marker Not Found'),
                content: Text('Marker not found in redeemers account'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
                ],
              ));
              return false;
            }
        }
      else
        {
          showDialog(context: context, builder: (builder)=>AlertDialog(
            title: Text('Redeemer not found'),
            content: Text('Redeemer does not have an account in food flag'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          ));
          return false;
        }
    }
    catch(e)
    {
        print('Error in checkExistance $e');
        return false;
    }
  }

  Future<void> verifyAndGive(String receiver_id, String marker_id, String creator_id, String rest_id)
  async {
    final receiverRef = firestore.FirebaseFirestore.instance.collection('users').doc(receiver_id);

    // Step 1: Delete the entry from receiver's 'received' map with `creator_id` as the key
    await receiverRef.update({
      'received.$creator_id': firestore.FieldValue.delete(),
    });

    // Step 2: Delete from restaurant's 'unverifiedMarkers' map
    final restaurantRef = firestore.FirebaseFirestore.instance.collection('restaurants').doc(rest_id);
    await restaurantRef.update({
      'unverifiedMarkers.$marker_id': firestore.FieldValue.delete(),
    });

    // Step 3: Add the marker to the restaurant's 'records' subcollection
    final creatorRestRecordRef = restaurantRef.collection('records').doc(creator_id);
    // Update the receiver_id field in the markers map under marker_id
    await creatorRestRecordRef.update({
      'markers.$marker_id.receiver_id': receiver_id,
    });
    // Step 4: Delete from creator's running flags and markerDocs (if needed)
    final creatorRef = firestore.FirebaseFirestore.instance.collection('users').doc(creator_id);
    await creatorRef.update({
      'runningFlags.$receiver_id': firestore.FieldValue.delete(),
      'donated': firestore.FieldValue.increment(1),
    });
    await creatorRef.collection('markersDoc').doc(marker_id).delete();

    print("Verification and flag transfer completed successfully.");

    showDialog(context: context, builder: (builder)=>AlertDialog(
      title: Text('Meal Redeemed'),
      content: Text('Meal has been redeemed Successfully'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
          Navigator.pop(context);
        }, child: Text('OK'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify and Issue meal"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(160, 88, 176, 89),

        ),
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
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
                      controller: MobileScannerController(detectionSpeed: DetectionSpeed.unrestricted),
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
                        width: 160,
                        child: FloatingActionButton(onPressed: () async {
                          if(_processQrCode(qrCodeText)) {
                            if (await _checkExistence(receiver_id, marker_id, creator_id, rest_id)) {
                              showDialog(context: context, builder: (builder)=>AlertDialog(
                                title: Text('Marker Found'),
                                content: Text('Marker Found of $amount rs'),
                                actions: [
                                  TextButton(
                                      onPressed: () {verifyAndGive(receiver_id, marker_id, creator_id, rest_id);
                                        },
                                      child: Text('Issue Meal')),

                                  TextButton(onPressed: ()=>Navigator.pop(context), child: Text('Cancel'))
                                ],
                              ));
                            }
                          }
                        }, child: Text('Retrieve Information'),),
                      )
            ])
          ),
          ),
        ])
      )
    );
  }
}