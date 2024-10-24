import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class VerifyScan extends StatefulWidget {
  const VerifyScan({super.key});

  @override
  State<VerifyScan> createState() => _VerifyScanState();
}

class _VerifyScanState extends State<VerifyScan> with SingleTickerProviderStateMixin {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _pin = TextEditingController();
  late MobileScannerController _cameraController = MobileScannerController();
  String uid = '';
  String markerId = '';

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


  void _processQrCode(String QrText)
  {
    List<String>parts = QrText.split('~');
    if(parts.length == 2)
    {
      uid = parts[0];
      markerId = parts[1];

      print('$uid, $markerId');
    }
    else
    {
      print('Invalid Qr Code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Qr"),
        centerTitle: true,

        ),
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Scanner(controller: _cameraController),

                      Container(
                        width: 160,
                        child: FloatingActionButton(
                          onPressed: () {},
                          child: Text("Verify"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class Scanner extends StatelessWidget {
  final MobileScannerController controller;
  const Scanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      width: 300,
      height: 300,
      child: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              // Handle QR code detection here
              print(capture);
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
    );
  }
}