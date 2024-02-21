import 'package:FoodFlag/services/createuserdoc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:FoodFlag/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:FoodFlag/pages/caught_flag.dart';
import 'package:FoodFlag/pages/dashboard.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String name ="";
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {

        User? user = authState.currentUser;

        FirebaseFirestore.instance.collection('users').doc(user?.uid).get().then((DocumentSnapshot snapshot){
          if (snapshot.exists) {
            // Access the 'name' field from the document snapshot
            String userName = snapshot['name'];

            // Now you can use userName variable to display the name
            setState(() {
              name = userName;
            });
          } else {
            print('Document does not exist on the database');
          }
        }).catchError((error) {
          print('Error getting document: $error');
        });

        return Drawer(
          backgroundColor: const Color.fromARGB(220, 55, 135, 112),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  name?? "",
                  style: GoogleFonts.arbutusSlab(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                accountEmail: Text(authState.currentUser?.email ?? "Not Signed in"),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.green, Colors.lightGreen],
                  ),
                ),
                currentAccountPicture: ClipOval(
                  child: Image.network(
                    authState.currentUser?.photoURL ?? "",
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Image.asset("lib/img/notSigned.png");
                    },
                  ),
                ),
              ),

              // All icons in drawer are listed here
              SizedBox(height: 10),
              Text("For Individuals",textAlign: TextAlign.left, style: GoogleFonts.marcellus(
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 213, 245, 227)),
              ),),

              ListTile(
                onTap: () async {
                  bool userExists = await UserService.checkUserExists(user?.uid);
                  Navigator.pushNamed(context, authState.currentUser?.email == null && !userExists ? '/settingspage' : '/hoistpage');
                },
                leading: const Icon(Icons.flag_circle_rounded, size: 39, color: Colors.pinkAccent),
                title: Text(
                  'Hoist Flag',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
              ),

              ListTile(
                onTap: () {
                  if (authState.currentUser != null) {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dashboard();
                      },
                    );
                  } else {
                    // User is not signed in, handle accordingly
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in to access the dashboard')),
                    );
                  }
                },
                leading: const Icon(Icons.dashboard, size: 39, color: Colors.white70),
                title: Text(
                  'Dashboard',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
              ),

              ListTile(
                onTap: () {
                  if (authState.currentUser != null){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const Caughtflag();
                    },
                  );
                  }else {
                    // User is not signed in, handle accordingly
                       ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Please sign in to access the caught flag')),
                       );
                        }
                },
                leading: const Icon(Icons.flag, size: 39, color: Colors.lightGreen),
                title: Text(
                  'Caught Flag',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/settingspage');
                },
                leading: const Icon(Icons.settings, size: 39, color: Colors.grey),
                title: Text(
                  'Login/Signup',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Text("For Restaurants",textAlign: TextAlign.left, style: GoogleFonts.marcellus(
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 213, 245, 227)),
              ),),

              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/restsettings');
                },
                leading: const Icon(Icons.restaurant, size: 39, color: Colors.black45),
                title: Text(
                  'Restaurant Sign Up',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
              ),

              ListTile(
                onTap: () {
                  /* Function call for message here */
                },
                leading: const Icon(Icons.verified_user, size: 39, color: Colors.grey),
                title: Text(
                  'Verifier',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
