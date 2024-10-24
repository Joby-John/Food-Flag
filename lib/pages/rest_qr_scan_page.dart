import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_core/firebase_core.dart';

class QrScan extends StatefulWidget {
  const QrScan({super.key});

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> with SingleTickerProviderStateMixin {
  final TextEditingController _amount = TextEditingController(text: '10');
  final TextEditingController _count = TextEditingController(text: '1');
  String qrCodeText = '';
  String uid = '';
  String cause = '';

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
      uid = parts[0];
      cause = parts[1];

      print('$uid, $cause');
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

  void _validateAndCreateFlag()
  {
    String errorMessage = '';
    int? amount = int.tryParse(_amount.text);
    int? count = int.tryParse(_count.text);

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
      }
  }

  Future<bool> _checkUID(String qrUID) async
  {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(qrUID).get();
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
                    if(await _checkUID(uid))
                      {
                        _validateAndCreateFlag();
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