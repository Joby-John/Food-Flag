import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Getter for the current user
  User? get currentUser => _auth.currentUser;

  /// Signs in the user using Google Sign-In
  Future<void> googleSignIn(context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      //start google sign-in process
      final GoogleSignInAccount? googleUser =  await _googleSignIn.signIn();
      if(googleUser == null)
        {
          //user cancelled the sign in, so exit the function
          return;
        }

      //get google authentication credentials
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      //using google authentication credentials to sign in with Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      notifyListeners();

      //navigate to home page after sign in
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (error) {
      print(error);
    }

  }


  /// Signs out the current user
  Future<void> signOut(context) async {
    try {
      print("Looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooook");
      await _auth.signOut();
      await _googleSignIn.signOut();

      notifyListeners();

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('Error signing out: $e');
      // Rethrow the error for handling elsewhere if needed
    }
    notifyListeners();
  }


}
