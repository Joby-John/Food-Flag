import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../services/auth.dart';


    class DisplayQr extends StatefulWidget {
      const DisplayQr({super.key});

      @override
      State<DisplayQr> createState() => _DisplayQrState();
    }

    class _DisplayQrState extends State<DisplayQr> {
      bool _showPin = false;
      Timer? _timer;

      void _showPinTemporarily()
      {
        setState(() {
          _showPin = true;
        });

        _timer?.cancel();

        _timer = Timer(const Duration(seconds: 5), () {
          setState(() {
            _showPin = false;
          });
        });
      }

      @override
      void dispose()
      {
        _timer?.cancel();
        super.dispose();
      }


      Future<Map<String, dynamic>> _getUserDetails(String uid) async {
        try {
          DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
          return snapshot.data() as Map<String, dynamic>;
        } catch (e) {
          throw Exception("Failed to load user data");
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(centerTitle: true,
            title: Text(
              "My QR Code",
              style: GoogleFonts.marcellus(
                  textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
            ),
            backgroundColor: const Color.fromARGB(255, 46, 204, 113),),
          body: Center(
            child: Consumer<AuthState>(
              builder: (context, authstate, child)
              {
                final user = authstate.currentUser;

                if(user!= null)
                  {
                    print('Current User: ${user?.uid}');

                    return FutureBuilder<Map<String, dynamic>>(
                        future: _getUserDetails(user.uid),
                        builder: (context, snapshot){
                          if(snapshot.connectionState ==ConnectionState.waiting)
                            {
                              return const CircularProgressIndicator();
                            }
                          else if(snapshot.hasError)
                            {
                              return const Text("Error loading QR CODE! try again");
                            }
                          else if(snapshot.hasData)
                            {
                               final userData = snapshot.data!;
                               String qrData =
                                   '${user.uid}&${userData['name'] ?? 'anonymous'}';

                               return Column(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: [
                                   QrImageView(
                                       data: qrData,
                                       version: QrVersions.auto,
                                       size: 200.0,
                                   ),

                                   if(_showPin)
                                     Text('PIN:${userData['pin']}'),

                                   Center(
                                     child: ElevatedButton(
                                       onPressed: _showPinTemporarily,
                                       child: Text(_showPin?"Pin Visible":"Show Pin"),
                                     ),
                                   )
                                 ],
                               );
                            }
                          else
                            {
                              return Text("Error");
                            }
                        }
                    );
                  }
                else
                  {
                    return Text("Error Retrieving Details please Restart the App");
                  }
              },
            )
          ),
        );
      }
    }
