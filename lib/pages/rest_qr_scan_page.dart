import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QrScan extends StatefulWidget {
  const QrScan({super.key});

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final TextEditingController _amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Scan Qr"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [Tab(icon: Icon(Icons.flag_circle),text: 'Raise Flag',),
                   Tab(icon: Icon(Icons.delete_forever), text: 'Delete Flag',)],
          ),),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: SafeArea(
        child:Center(child: Column(
            children: [
              Scanner(),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: 210,

                child: TextField(
                  controller: _amount,

                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.money, size: 33,),
                      labelText: 'Enter Amount',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                )
                ),
              ),
              Container(
                width: 160,
                child: FloatingActionButton(onPressed: (){}, child: Text("Create Flag"),),
              )
            ],
            ),
            ),
    ),
            ),

            SingleChildScrollView(
              child: SafeArea(
                child:Center(child: Column(
                  children: [
                    Scanner(),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      width: 210,

                      child: TextField(
                          controller: _amount,
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 21,

                          ),
                          textAlign: TextAlign.center,


                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.password, size: 25,),
                            labelText: "Enter Pin",
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                          )
                      ),
                    ),
                    Container(
                      width: 160,
                      child: FloatingActionButton(onPressed: (){}, child: Text("Delete Flag"),),
                    )
                  ],
                ),
                ),
              ),
            )
          ],
        ),

      ),

    );
  }
}

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        width: 300,
        height: 300,

        child: Stack(
          children: [
            MobileScanner(onDetect: (Capture) {

            },
            ),

            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.lightGreen,
                    width: 4.0
                ),
              ),
            )
          ],
        )
    );
  }
}

