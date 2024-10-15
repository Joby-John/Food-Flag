import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for the current user
  User? get currentUser => _auth.currentUser;

  /// Signs in the user using Google Sign-In
  Future<void> googleSignIn(context) async {
    try {
      await _auth.signOut();

      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(googleAuthProvider);
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }


  /// Signs out the current user
  Future<void> signOut(context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('Error signing out: $e');
      // Rethrow the error for handling elsewhere if needed
    }
    notifyListeners();
  }


}
