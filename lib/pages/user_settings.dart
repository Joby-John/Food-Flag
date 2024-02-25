import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:FoodFlag/services/auth.dart';
import 'package:FoodFlag/services/createuserdoc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String name = ''; // Initialize the name variable
  String phone = '';
  bool _isNameSubmitted = false;
  bool _isPhoneSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 55, 135, 112),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Signup/Login",
          style: GoogleFonts.marcellus(
              textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ),
        backgroundColor: Color.fromARGB(255, 46, 204, 113),
      ),
      body: Consumer<AuthState>(
        builder: (context, authState, child) {
          User? user = authState.currentUser;
          return ListView(
            padding: const EdgeInsets.all(10),
              children: [
                const SizedBox(height: 20,),
                Center(
                child: SizedBox(
                  height: 100,
                  child: DefaultTextStyle(style: GoogleFonts.aclonica(
                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70,
                      shadows:[Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(0,0))]
                  ),
                ),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      FlickerAnimatedText('Full !  Hoist a Flag'),
                      FlickerAnimatedText('Hungry !  catch a Flag'),

                    ],
                  )
                  ),
                ),
                ),

                const SizedBox(height: 20,),
                _buildImage(),

                SizedBox(
                  width: 300,
                  child: Text('Food Flag', style: GoogleFonts.marcellus(
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70,
                        shadows:[Shadow(blurRadius: 5.0, color: Colors.black, offset: Offset(0,0))]
                    ),
                  ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                if (user?.email==null) ...[
                  _buildNameField(),
                  const SizedBox(height: 10,),
                  _buildPhoneField(),
                  ],
                  const SizedBox(height: 20),
                  Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: user != null
                           ?_IndividualSignOutButton(context)
                           : _IndividualSignInButton(context, name), // Pass context here
                     ),

              ],

          );
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      onChanged: (value) {
        setState(() {
          name = value;
          _isNameSubmitted = value.isNotEmpty;
        });
      },
      decoration: const InputDecoration(
        hintText: 'Once set, you wont be able to change this',
        labelText: 'Name',
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      onChanged: (value) {
        setState(() {
          phone = value;
          _isPhoneSubmitted = value.isNotEmpty;
        });
      },
      decoration: InputDecoration(
        hintText: 'Enter your phone number',
        labelText: 'Phone',
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      'lib/img/FoodFlag.png',
      height: 100,
      width: 100,
    );
  }


  // Sign in with Google and create user document
  Future<void> signIn(context, String name, String phone) async {
    await Provider.of<AuthState>(context, listen: false).googleSignIn(context);


    AuthState authState;
    authState = Provider.of<AuthState>(context, listen: false);
    User? user = authState.currentUser;
    bool restExists = await UserService.checkRestExists(user?.uid);
    if (restExists) {
      // User already exists, prompt to log in with a different account
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Account already in use for restaurant'),
            content: Text('Please use a different account.'),
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
    }else {
      await UserService.signInAndCreateUserDocument(context, name, phone);
    }
  }

  // Widget for individual sign-in button
  Widget _IndividualSignInButton(BuildContext context, String name) {
    return Center(
      child: SizedBox(
        height: 33,
        width: 120,
        child: SignInButton(
          Buttons.google,
          text: "Sign In",
          onPressed: () {
            if(_isNameSubmitted&&_isPhoneSubmitted) {
              signIn(context, name, phone);
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please Enter Name and Phone number')),
              );
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget for individual sign-out button
  Widget _IndividualSignOutButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 33,
        width: 120,
        child: SignInButton(
          Buttons.googleDark,
          text: "Sign Out",
          onPressed: () {
            Provider.of<AuthState>(context, listen: false).signOut(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget to display user information
  Widget _userInfo(User? user) {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (user != null)
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user.photoURL ?? ""),
              ),
            ),
          ),

        Text(user?.email ?? "Not Signed In"),
        Text(name?? ""),

        const SizedBox(height: 200),
        const Text(
          "Restaurants Should Create account in Restaurant Sign Up Section before trying to log in",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        )
      ],
    );
  }
}
