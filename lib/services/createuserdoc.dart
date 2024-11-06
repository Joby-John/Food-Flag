import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

import 'dart:math';

class UserService {

  static Future<bool> checkUserExists(String? uid) async {
    try {
      if (uid != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        return userDoc.exists;
      }
      return false;
    } catch (error) {
      print('Error checking user existence: $error');
      return false;
    }
  }

  static Future<bool> checkRestExists(String? uid) async {
    try {
      if (uid != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('restaurants').doc(uid).get();
        print("Rest check just worked");
        return userDoc.exists;

      }
      return false;
    } catch (error) {
      print('Error checking user existence: $error');
      return false;
    }
  }


  static Future<void> signInAndCreateUserDocument(BuildContext context, String name, String phone) async {
    print("NOW WORKING 1");
    try {
      print("NOW WORKING");
      final authState = Provider.of<AuthState>(context, listen: false);
      final user = authState.currentUser;

      if (user != null) {
        await _createUserDocument(user, name, phone);
      } else {
        print("USER IS NULL");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating account, Please login again to try again.')),
      );
      print('Error signing in and creating user document: $error');
    }
  }

  static Future<void> _createUserDocument(User user, String name, String phone) async {
    try {
      // Firestore automatically creates a collection when a document is added to it.
      // However, in this case, we're checking for an existing document in the 'restaurants' collection.
      // If we skip this check and directly create the document, it could overwrite existing data if the user tries to create an account again.
      // By checking if the document exists first, we avoid this issue and prevent overwriting existing user data.
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        String pin = _generatePin();
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'uid': user.uid,
          'donated': 0,
          'received': 0,
          'markers': {},
          'received':{},
          'runningFlags':{},
          'phone': phone,
          'role': "regular",
          'pin': pin,
          //'type':'unpaid'// because al the unpaid like functions, temple churches can be included here
        });
      }
    } catch (error) {
      print('Error creating user document: $error');
    }
  }

    //most probably ill get rid of this pin as i don't think i need it at any part
  static String _generatePin()
  {
    Random random = Random();
    int pin = random.nextInt(9000) + 1000;
    return pin.toString();
  }

}

class RestaurantService {
  static Future<void> signInAndCreateRestaurantDocument( AuthState authState, BuildContext context,
      String name, String fssai, String phone, String? location) async {
    print("NOW WORKING 1");
    try {
      print("NOW WORKING");
      //final authState = Provider.of<AuthState>(context, listen: false);
      final user = authState.currentUser;
      print("authState works");

      if (user != null) {
        await _createRestaurantDocument(context, user, name, fssai, phone, location);
      } else {
        print("USER IS NULL");
      }
    } catch (error) {
      print('Error signing in and creating restaurant document: $error');
    }
  }

  static Future<void> _createRestaurantDocument( BuildContext context,User user, String name, String fssai, String phone, String? location) async {
    try {
      print("This works at 119 of createuserdoc");
      // Firestore automatically creates a collection when a document is added to it.
      // However, in this case, we're checking for an existing document in the 'restaurants' collection.
      // If we skip this check and directly create the document, it could overwrite existing data if the user tries to create an account again.
      // By checking if the document exists first, we avoid this issue and prevent overwriting existing user data.

      final userDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('restaurants')
            .doc(user.uid)
            .set({
          'name': name,
          'uid': user.uid,
          'fssai': fssai,
          'phone': phone,
          'DonationCount':0,
          'location': location,
          'unverifiedMarkers':{}, //marker_id:amount and on verify delete
          'role': "restaurant"
          //'type':'paid'// bc all the paid ones like restaurants can be included here
        });

      }
    } catch (error) {
      print('Error creating user document: $error');

      // Show Snackbar with an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign Up failed. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3), // You can adjust the display duration
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () {
              // Optionally add a retry action
              // You could call the sign-up function again here
              final authstate  = Provider.of<AuthState>(context, listen: false);
              signInAndCreateRestaurantDocument(authstate,context, name, fssai, phone, location);
            },
            textColor: Colors.white,
          ),
        ),
      );

    }
  }


}