import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:FoodFlag/services/auth.dart';
import 'package:FoodFlag/services/createuserdoc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class LoginSignup extends StatefulWidget {
  const LoginSignup({Key? key}) : super(key: key);

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {

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

                  const SizedBox(height: 20),
                  Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: user != null
                           ?_IndividualSignOutButton(context)
                           : _IndividualSignInButton(context), // Pass context here
                     ),

                const SizedBox(height: 20),
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _userSignUp(context), // Pass context here
                ),

                const SizedBox(height: 20),
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _restaurantSignUp(context), // Pass context here
                ),
                

              ],

          );
        },
      ),
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
  Future<void> signIn(context) async {
    await Provider.of<AuthState>(context, listen: false).googleSignIn(context);


    AuthState authState;
    authState = Provider.of<AuthState>(context, listen: false);
    User? user = authState.currentUser;
    bool restExists = await UserService.checkRestExists(user?.uid);
    bool userExists = await UserService.checkUserExists(user?.uid);

    if (restExists) {
      // User already exists, prompt to log in with a different account
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logged in as restaurant'),
            content: Text('This account is in use for restaurant'),
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
    }else if(userExists)
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Logged in as User'),
              content: Text('You can now catch and raise flags'),
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
      }
    else{

      await Provider.of<AuthState>(context, listen: false).signOut(context);

      setState(() {});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Account not found"),
            content: Text('Please sign Up to continue'),
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


    }
  }

  // Widget for individual sign-in button
  Widget _IndividualSignInButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 33,
        width: 120,
        child: SignInButton(
          Buttons.google,
          text: "Sign In",
          onPressed: () {
              signIn(context);

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

  Widget _userSignUp(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authstate, child) {
      return Center(
        child: SizedBox(
          height: 33,
          width: 200,
          child: SignInButton(
            Buttons.google,
            text: "Create User account",
            onPressed: () {
              if (authstate.currentUser == null) {
                Navigator.pushNamed(context, '/userSignupPage');
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign out first'))
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
    );
  }

  Widget _restaurantSignUp(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authstate, child){
      return Center(
        child: SizedBox(
          height: 33,
          width: 300,
          child: SignInButton(
            Buttons.google,
            text: "Create Restaurant account",
            onPressed: () {
              if (authstate.currentUser == null) {
                Navigator.pushNamed(context, '/restsettings');
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign out first'))
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
    );
  }


}
