import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class PayNRaise extends StatefulWidget {
  const PayNRaise({super.key});

  @override
  State<PayNRaise> createState() => _PayNRaiseState();
}

class _PayNRaiseState extends State<PayNRaise> {
  TextEditingController _amountController = TextEditingController();
  bool _isButtonEnabled = false;
  String? rawValue;
  String upiID = "";
  String name = "";
  DocumentReference restUsersDocRef = FirebaseFirestore.instance
      .collection('restaurants')
      .doc('restaurantUsers');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pay and Raise",
          style: GoogleFonts.marcellus(
              textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 46, 204, 113),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // QR Code Scanner Widget
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.4, // Fixed height for QR code scanner
                child: MobileScanner(
                    controller: MobileScannerController(
                        detectionSpeed: DetectionSpeed.noDuplicates),
                    onDetect: (capture) async {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        rawValue = barcode.rawValue;
                      }
                      setState(() {
                        upiID = extractUPIId(rawValue!);
                        name = extractName(rawValue!);
                      });

                      // checking for restaurant existence in db
                      DocumentSnapshot snapshot = await restUsersDocRef.get();
                      Map<String, dynamic>? data =
                          snapshot.data() as Map<String, dynamic>?;

                      if (data != null && !data.containsKey(upiID)) {
                        // UPI ID does not exist, show an alert dialog
                        setState(() {
                          upiID = "";
                          name = "";
                        });

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('UPI ID not found'),
                              content: Text(
                                  'The UPI ID $upiID does not exist in the database.'),
                              actions: [
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
                    }), // Implement QR code scanner here
              ),

              // Non-editable text fields
              SizedBox(
                height: 21,
              ),
              Text(
                "UPI ID: $upiID",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 21,
              ),
              Text(
                "Name: $name",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 21,
              ),

              // Editable text field for numbers
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter a number",
                  border: OutlineInputBorder(),
                  errorText:
                      _isButtonEnabled ? null : "Please enter the amount",
                ),
                onChanged: (value) {
                  setState(() {
                    // Enable or disable the button based on whether the text field is empty
                    if(upiID!="") { // if the upi id is not found in db
                      _isButtonEnabled = value.isNotEmpty;
                    }
                  });
                },
              ),

              SizedBox(
                height: 30,
              ),

              // Button
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        // Implement button functionality here
                      }
                    : null,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String extractUPIId(String text) {
  RegExp regExp = RegExp(r'pa=([\w\.-]+@[\w\.-]+)');
  Match? match = regExp.firstMatch(text);
  String upiId = match?.group(1) ?? ""; // Get the first capture group
  return upiId;
}

String extractName(String text) {
  RegExp regExp = RegExp(r'pn=([\w%]+)');
  Match? match = regExp.firstMatch(text);
  String name = match?.group(1) ?? ""; // Get the first capture group
  name = Uri.decodeComponent(name); // Decode URL encoding
  return name;
}
