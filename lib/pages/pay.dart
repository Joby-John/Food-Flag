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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay and Raise", style: GoogleFonts.marcellus(
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
                height: MediaQuery.of(context).size.height * 0.4, // Fixed height for QR code scanner
                child: MobileScanner(
                    onDetect: (capture){}), // Implement QR code scanner here
              ),
          
              // Non-editable text fields
              SizedBox(height: 21,),
              Text(
                "UPI ID: sample@okaxis",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 21,),
              Text(
                "Name: Tony Stark",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 21,),
          
              // Editable text field for numbers
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter a number",
                  border: OutlineInputBorder(),
                  errorText: _isButtonEnabled ? null : "Please enter the amount",
                ),
                onChanged: (value) {
                  setState(() {
                    // Enable or disable the button based on whether the text field is empty
                    _isButtonEnabled = value.isNotEmpty;
                  });
                },
              ),
          
              SizedBox(height: 30,),
          
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

