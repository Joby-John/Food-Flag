import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth.dart';

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
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'uid': user.uid,
          'donated': 0,
          'received': 0,
          'markers': {},
          'received':{},
          'runningFlags':{},
          'phone': phone,
          //'type':'unpaid'// because al the unpaid like functions, temple churches can be included here
        });
      }
    } catch (error) {
      print('Error creating user document: $error');
    }
  }
}

class RestaurantService {
  static Future<void> signInAndCreateRestaurantDocument(BuildContext context,
      String name, String upiID, String fssai, String pan, String phone) async {
    print("NOW WORKING 1");
    try {
      print("NOW WORKING");
      final authState = Provider.of<AuthState>(context, listen: false);
      final user = authState.currentUser;

      if (user != null) {
        await _createRestaurantDocument(user, name, upiID, fssai, pan, phone);
      } else {
        print("USER IS NULL");
      }
    } catch (error) {
      print('Error signing in and creating restaurant document: $error');
    }
  }

  static Future<void> _createRestaurantDocument(User user, String name,
      String upiID, String fssai, String pan, String phone) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('restaurants')
            .doc(user.uid)
            .set({
          'name': name,
          'upiID': upiID,
          'uid': user.uid,
          'fssai': fssai,
          'pan': pan,
          'phone': phone,
          'moneyLeft': 0,
          'unverifiedMarkers':{},
          'markers': {},
          //'type':'paid'// bc all the paid ones like restaurants can be included here
        });
        // to create RID:UID pair
        await _addUPIToRestaurantUsers(upiID, user.uid);
      }
    } catch (error) {
      print('Error creating user document: $error');
    }
  }

  static Future<void> _addUPIToRestaurantUsers(String upiID, String uid) async {
    try {
      // Create a reference to the restaurantUsers document
      DocumentReference restaurantUsersDocRef = FirebaseFirestore.instance
          .collection('restaurants').doc('restaurantUsers');

      // Update the document with the new rid:uid pair
      await restaurantUsersDocRef.set({
        upiID: uid,
      }, SetOptions(
          merge: true)); // Merge option ensures that existing fields are preserved
    } catch (error) {
      print('Error adding upiID:uid to restaurantUsers document: $error');
    }
  }

}