import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for the current user
  User? get currentUser => _auth.currentUser;

  /// Signs in the user using Google Sign-In
  Future<void> googleSignIn() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
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
