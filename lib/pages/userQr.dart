import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      final TextEditingController _causeController = TextEditingController();
      bool _showQr = false;
      String _qrData = '';
      Timer? _timer;



      @override
      void dispose()
      {
        _causeController.dispose();
        super.dispose();
      }

      void _createQrCode(String uid)
      {
        final cause = _causeController.text.trim();
        final qrCause = cause.isNotEmpty?cause:'Just felt so';

        if(qrCause.isNotEmpty)
          {
            setState(() {
              _qrData = '${uid}~${qrCause}';
              _showQr = true;
            });
          }
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

                               return SingleChildScrollView(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     if(_showQr)
                                       QrImageView(
                                           data: _qrData,
                                            version: QrVersions.auto,
                                            size: 200.0,
                                       ),

                                     const SizedBox(
                                       height: 70,
                                     ),
                                 
                                     Padding(
                                         padding:const EdgeInsets.all(8.0),
                                         child: TextField(
                                           controller: _causeController,
                                           obscureText: true,
                                           inputFormatters: [LengthLimitingTextInputFormatter(25)],
                                           decoration: InputDecoration(
                                             labelText: "Enter Cause,  default is 'Just felt so'",
                                             border: OutlineInputBorder(
                                               borderRadius: BorderRadius.all(Radius.circular(25))
                                             )
                                           ),
                                         ),
                                     ),

                                     const SizedBox(
                                       height: 70,
                                     ),
                                 
                                     Center(
                                       child: ElevatedButton(
                                         onPressed: (){_createQrCode(user.uid);},
                                         child: Text("Create QR"),
                                       ),
                                     )
                                   ],
                                 ),
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
