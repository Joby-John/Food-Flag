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
  void initState()
  {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName()
  async {
    User? user = Provider.of<AuthState>(context, listen: false).currentUser;

    if(user == null)
      {
        return;
      }
    try{
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if(userSnapshot.exists)
        {
          setState(() {
            name = userSnapshot['name'];
          });
        }
      else{
        DocumentSnapshot restSnapshot = await FirebaseFirestore.instance.collection('restaurants').doc(user.uid).get();

        if(restSnapshot.exists)
          {
            setState(() {
              name = restSnapshot['name'];
            });
          }
        else
          {
            print('Document does not exist in the database');
          }
      }
    }
    catch(e)
    {
      print('Error retrieving document $e');
    }
  }

  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, child) {

        User? user = authState.currentUser;

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


              ListTile(
                onTap: () async {
                  bool userExists = await UserService.checkUserExists(user?.uid);
                  if (authState.currentUser != null && userExists){
                        Navigator.pushNamed(context, '/hoistpage');
                  }else {
                    // User is not signed in, handle accordingly
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in with Individual account to access the Hoist Flag')),
                    );
                  }
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
                onTap: () async {
                  bool userExists = await UserService.checkUserExists(user?.uid);
                  if (authState.currentUser != null && userExists) {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const Dashboard();
                      },
                    );
                  } else {
                    // User is not signed in, handle accordingly
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in as user to access the dashboard')),
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
                onTap: () async {
                  bool userExists = await UserService.checkUserExists(user?.uid);
                  if (authState.currentUser != null && userExists){
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const Caughtflag();
                    },
                  );
                  }else {
                    // User is not signed in, handle accordingly
                       ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Please sign in with Individual account to access the caught flag')),
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
                  Navigator.pushNamed(context, '/LoginSignupPage');
                },
                leading: const Icon(Icons.login_rounded, size: 39, color: Colors.green),
                title: Text(
                  'Sign up / Log In',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Divider(height: 20, thickness: 1.6, color: Colors.white30,),
              SizedBox(height: 13,),
              // ListTile(
              //   onTap: () {
              //     if (authState.currentUser == null){
              //       Navigator.pushNamed(context, '/restsettings');
              //     }else {
              //       // User is not signed in, handle accordingly
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('Please sign out first')),
              //       );
              //     }
              //   },
              //   leading: const Icon(Icons.restaurant, size: 39, color: Colors.grey),
              //   title: Text(
              //     'Restaurant Sign Up',
              //     style: GoogleFonts.marcellus(
              //       textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
              //     ),
              //   ),
              // ),

              ListTile(
                onTap: () async {
                  bool restExists = await UserService.checkRestExists(user?.uid);
                  if(authState.currentUser != null && restExists ) {
                    Navigator.pushNamed(context, '/scanQr');
                  }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Only Restaurants can add Restaurant Flag')),
                      );
                    }
                },
                leading: Icon(Icons.add_location_alt_sharp, size: 39, color: Colors.lightGreen,),
                title:  Text(
                  'Add Restaurant Flag',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),

              ),

              ListTile(
                onTap: () async {
                  bool restExists = await UserService.checkRestExists(user?.uid);

                  if(authState.currentUser!=null && restExists) {
                    Navigator.pushNamed(context, '/verifyQr');
                  }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Only Restaurants can verify Restaurant Flag')),
                      );
                    }
                },
                leading: Icon(Icons.card_giftcard_rounded, size: 39, color: Colors.pinkAccent[700],),
                title:  Text(
                  'Verify Restaurant Flag',
                  style: GoogleFonts.marcellus(
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                ),

              )

            ],
          ),
        );
      },
    );
  }
}
