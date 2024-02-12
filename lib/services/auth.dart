import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for the current user
  User? get currentUser => _auth.currentUser;

  /// Signs in the user using Google Sign-In
  Future<void> googleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      await _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }


  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      // Rethrow the error for handling elsewhere if needed
    }
    notifyListeners();
  }
}
