import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static String email = "Not signed in ";
  static String name = "";
  static String img_Url = "";


  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
        Settings.email = _user?.email ?? "Not Signed In";
        Settings.name  = _user?.displayName ?? "";
        Settings.img_Url = _user?.photoURL ?? "";
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 236, 252, 252),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Settings", style: GoogleFonts.marcellus(
              textStyle: const TextStyle(fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)
          )),
          backgroundColor: Colors.blueAccent,

        ),

        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                SizedBox(height: 40,),
                Row(
                  children: [
                  Icon(Icons.person, color: Colors.blue, size: 37,),

                    Expanded(
                      child: Text(
                          "Individual: ", style: GoogleFonts.marcellus(
                          textStyle: const TextStyle(fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)
                      )),
                    ),

                    Expanded(
                      child: _user != null
                          ? _IndividualSignOutButton()
                          : _IndividualSignInButton(),)

                  ],
                ),
                Row(
                  children: [
                     Icon(
                        Icons.restaurant, color: Colors.blue, size: 37,),

                    Expanded(
                      child: Text("Restaurant                  ",
                          style: GoogleFonts.marcellus(
                              textStyle: const TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54)
                          )),
                    ),

                    Expanded(
                      child: _RestaurantSignInButton(),)

                  ],
                ),
                Row(
                  children: [
                    Flexible(
                        flex:1,
                        child: _userInfo())
                  ],

                )
              ],
            )
        )
    );
  }

  Widget _IndividualSignInButton() {
    return Center(
      child: SizedBox(
        height: 33,
        width:120,
        child: Center(
          child: SignInButton(
            Buttons.google, text: "Google", onPressed: _handleGoogleSignIn,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),),
        )
        ,),
    );
  }

  Widget _IndividualSignOutButton() {
    return Center(
      child: SizedBox(
        height: 33,
        width:120,
        child: SignInButton(
          Buttons.googleDark, text: "Sign Out", onPressed: _auth.signOut,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }


  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }

  Widget _RestaurantSignInButton() {
    return Center(
      child: SizedBox(
        height: 33,
        width:120,
        child: SignInButton(
          Buttons.anonymous, text: "Sign in", onPressed: () {},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),)
        ,),
    );
  }

  Widget _userInfo()
  {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(image: DecorationImage(image:NetworkImage(_user?.photoURL ?? "")),
          )
          ),
          Text(_user?.email ?? "Not Signed In"),
          Text(_user?.displayName ?? ""),
        ],

      )
    );
  }
}