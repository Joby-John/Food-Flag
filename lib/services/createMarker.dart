import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addMarker(GeoPoint location, String type, String name, String origin, int amount, bool available) async {
  try {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;

    // Check if user is signed in
    if (user != null) {
      // Get user UID
      String uid = user.uid;

      // Create marker document in marker sub-collection with auto-generated document ID
      CollectionReference markersCollectionRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('markersDoc');
      var markerDocRef = await markersCollectionRef.add({
        'origin':origin,
        'location': location,
        'type': type,
        'name': name,
        'amount': amount,
        'code': markersCollectionRef.doc().id,
        'available': available,
      });
      String markerDocId = markerDocRef.id;

      await markerDocRef.update({'code': markerDocId});


      // Update user document with the marker title as the marker document ID
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'markers.$markerDocId': {
          'location': location,
          'type': type,
          'amount': amount,
          'origin': origin,
        },
      });

      // Increment the donated field in the user document using a transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(FirebaseFirestore.instance.collection('users').doc(uid));
        if (userDoc.exists) {
          int donated = userDoc['donated'] ?? 0;
          transaction.update(FirebaseFirestore.instance.collection('users').doc(uid), {'donated': donated + 1});
        }
      });


    } else {
      print('User is not signed in.');
    }
  } catch (error) {
    print('Error adding marker: $error');
  }
}
