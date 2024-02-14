import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

class UserService {
  static Future<void> signInAndCreateUserDocument(BuildContext context, String name) async {
    print("NOW WORKING 1");
    try {
      print("NOW WORKING");
      final authState = Provider.of<AuthState>(context, listen: false);
      final user = authState.currentUser;

      if (user != null) {
        await _createUserDocument(user, name);
      } else {
        print("USER IS NULL");
      }
    } catch (error) {
      print('Error signing in and creating user document: $error');
    }
  }

  static Future<void> _createUserDocument(User user, String name) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'donated': 0,
          'received': 0,
          'markers': {},
        });
      }
    } catch (error) {
      print('Error creating user document: $error');
    }
  }
}
