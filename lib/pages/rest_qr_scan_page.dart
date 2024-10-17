import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QrScan extends StatefulWidget {
  const QrScan({super.key});

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> with SingleTickerProviderStateMixin {
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _pin = TextEditingController();
  late MobileScannerController _cameraController = MobileScannerController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to tab changes
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          _cameraController.start();  // Start scanner on first tab
        } else if(_tabController.index == 1){
          _cameraController.start();   // Start scanner on second tab
        }
      });
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Qr"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.flag_circle), text: 'Raise Flag'),
            Tab(icon: Icon(Icons.verified), text: 'Verify and Donate'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Scanner(controller: _cameraController),
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
                      width: 160,
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Text("Create Flag"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Scanner(controller: _cameraController),
                    Container( ///change this to that pop up thing and it should display amount of the flag.
                      padding: const EdgeInsets.all(12.0),
                      width: 210,
                      child: TextField(
                        controller: _pin,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 21,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.password, size: 25),
                          labelText: "Enter Pin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                        ),
                      ),
                    ),
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
